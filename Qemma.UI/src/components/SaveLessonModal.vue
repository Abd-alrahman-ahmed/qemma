<template>
  <base-modal v-model="dialog" :title="title" modal-size="modal-md" >
    <base-form slot="body" :model="model" ref="form">
      <div class="row">
        <div class="col-12">
          <div class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.name")}}</label>
              <input type="text" onfocus="this.select();" class="form-control" v-model="model.name" 
                :placeholder="$locales.t('lesson.name.ph')" />
              <span data-validation-prop="name" 
                data-validation-rule="v => v != '' || 'lesson.name.invalid'" class="invalid-feedback" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.starttime")}}</label>
              <input type="datetime-local" onfocus="this.select();" class="form-control" v-model="model.start" 
                :placeholder="$locales.t('lesson.starttime.ph')" />
              <span data-validation-prop="start" 
                data-validation-rule="v => v != '' || 'lesson.starttime.invalid'" class="invalid-feedback" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.dictation")}}</label>
              <input type="number" onfocus="this.select();" class="form-control" v-model="model.inClassExamDegree" 
                :placeholder="$locales.t('lesson.dictation.ph')" min="1" max="99999999" />
              <span data-validation-prop="inClassExamDegree" 
                data-validation-rule="v => v > 0 || 'lesson.dictation.invalid'" class="invalid-feedback" />
            </div>
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.quiz")}}</label>
              <input type="number" onfocus="this.select();" class="form-control" v-model="model.quizDegree" 
                :placeholder="$locales.t('lesson.quiz.ph')" min="1" max="99999999" />
              <span data-validation-prop="quizDegree" 
                data-validation-rule="v => v > 0 || 'lesson.quiz.invalid'" class="invalid-feedback" />
            </div>
          </div>
        </div>
      </div>
    </base-form>
    <template slot="footer">
      <button class="btn btn-secondary" @click="dismiss">{{$locales.t('modals.close')}}</button>
      <button class="btn btn-primary" @click="save">{{$locales.t('modals.save')}}</button>
    </template>
  </base-modal>
</template>

<script>
import BaseModal from '@/components/BaseModal.vue'
import BaseForm from '@/components/BaseForm.vue'

export default {
  components: { BaseModal, BaseForm },
  name: 'SaveLessonModal',
  data: () => ({
    model: {
      id: '', name: '', teacherName: '', start: '',
      quizDegree: 0, homeworkDegree: 5, inClassExamDegree: 0,
      behaviourDegree: 5, interactionDegree: 5, groupId: ''
    },
    isEdit: false,
    id: 0,
    dialog: false,
  }),
  computed: {
    title() {
      let option = !this.isEdit ? "options.add" : "options.edit";
      return this.$locales.t(option);
    }
  },
  created() {
    this.$bus.$on("init-save-lesson-modal", (lesson=null, id=0, groupId='') => {
      this.model = Object.assign({}, {
        id: '', name: '', teacherName: '', start: '',
        quizDegree: 0, homeworkDegree: 5, inClassExamDegree: 0,
        behaviourDegree: 5, interactionDegree: 5, groupId: groupId
      });
      if (lesson != null) {
        lesson.start = this.$moment(lesson.start).local().format("YYYY-MM-DDThh:mm");
        Object.assign(this.model, lesson);
      }
      this.isEdit = lesson != null;
      this.id = id;
      this.dialog = true;
      if (this.$refs.form != undefined) this.$refs.form.resetValidation();
    });
  },
  mounted() {
    this.$el.addEventListener("keypress", function(event) {
      if (event.key === "Enter") {
        event.preventDefault();
        this.save();
      }
    }.bind(this));
  },
  methods: {
    dismiss() {
      this.dialog = false;
    },
    save() {
      this.model.quizDegree = parseInt(this.model.quizDegree);
      this.model.homeworkDegree = parseInt(this.model.homeworkDegree);
      this.model.inClassExamDegree = parseInt(this.model.inClassExamDegree);
      this.model.behaviourDegree = parseInt(this.model.behaviourDegree);
      this.model.interactionDegree = parseInt(this.model.interactionDegree);
      if(!this.$refs.form.validate()) return;
      this.model.start = this.$moment(this.model.start).utc()

      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/lessons${this.isEdit ? `/${this.model.id}`: ''}`,
        method: this.isEdit ? 'PUT' : 'POST',
        data: this.model
      }).then(data => {
        if (!this.isEdit) this.model.id = data;
        this.$bus.$emit("lesson-modal-done", this.isEdit, this.id, this.model);
        this.dismiss();
      });
    }
  }
}
</script>

<style>

</style>