<template>
  <base-modal v-model="dialog" :title="title" modal-size="modal-md" >
    <base-form slot="body" :model="model" ref="form">
      <div class="row">
        <div class="col-12">
          <div v-if="!isEdit && studentMissing" class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.studentname")}}</label>
              <v-select :dir="$locales.direction()" :clearable="true" :options="students" :reduce="student => student.id" label="name" 
                v-model="model.studentId" :placeholder="$locales.t('lesson.studentname.ph')" 
                required @option:selected="studentChanged">
                <template #no-options>
                  {{$locales.t("emptystate.default")}}
                </template>
              </v-select>
              <span data-validation-prop="studentId" 
                data-validation-rule="v => v != '' || 'lesson.studentname.invalid'" class="invalid-feedback" />
            </div>
          </div>
          <div v-if="!isEdit && lessonMissing" class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.lessonname")}}</label>
              <v-select :dir="$locales.direction()" :clearable="true" :options="lessons" :reduce="lesson => lesson.id" label="name" 
                v-model="model.lessonId" :placeholder="$locales.t('lesson.lessonname.ph')" 
                required @option:selected="lessonChanged">
                <template #no-options>
                  {{$locales.t("emptystate.default")}}
                </template>
              </v-select>
              <span data-validation-prop="lessonId" 
                data-validation-rule="v => v != '' || 'lesson.lessonname.invalid'" class="invalid-feedback" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.attend")}}</label>
              <v-select :dir="$locales.direction()" :clearable="false" :options="getAttendStaus" :reduce="attend => attend.state" label="name" 
                v-model="model.hasAttend" :placeholder="$locales.t('lesson.attend.ph')" required>
                <template #no-options>
                  {{$locales.t("emptystate.default")}}
                </template>
              </v-select>
              <span data-validation-prop="lessonId" 
                data-validation-rule="v => v != '' || 'lesson.attend.invalid'" class="invalid-feedback" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.paid")}}</label>
              <input type="number" onfocus="this.select();" class="form-control" v-model="model.paidAmount" 
                :placeholder="$locales.t('lesson.paid.ph')" min="0" max="99999999" />
              <span data-validation-prop="paidAmount" 
                data-validation-rule="v => v >= 0 || 'lesson.paid.invalid'" class="invalid-feedback" />
            </div>
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.quiz")}}</label>
              <input type="number" onfocus="this.select();" class="form-control" v-model="model.quizDegree" 
                :placeholder="$locales.t('lesson.quiz.ph')" min="0" max="99999999" />
              <span data-validation-prop="quizDegree" 
                data-validation-rule="v => v >= 0 || 'lesson.quiz.invalid'" class="invalid-feedback" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.homework")}}</label>
              <input type="number" onfocus="this.select();" class="form-control" v-model="model.homeworkDegree" 
                :placeholder="$locales.t('lesson.homework.ph')" min="0" max="99999999" />
              <span data-validation-prop="homeworkDegree" 
                data-validation-rule="v => v >= 0 || 'lesson.homework.invalid'" class="invalid-feedback" />
            </div>
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.dictation")}}</label>
              <input type="number" onfocus="this.select();" class="form-control" v-model="model.inClassExamDegree" 
                :placeholder="$locales.t('lesson.dictation.ph')" min="0" max="99999999" />
              <span data-validation-prop="inClassExamDegree" 
                data-validation-rule="v => v >= 0 || 'lesson.dictation.invalid'" class="invalid-feedback" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.behaviour")}}</label>
              <input type="number" onfocus="this.select();" class="form-control" v-model="model.behaviourDegree" 
                :placeholder="$locales.t('lesson.behaviour.ph')" min="0" max="99999999" />
              <span data-validation-prop="behaviourDegree" 
                data-validation-rule="v => v >= 0 || 'lesson.behaviour.invalid'" class="invalid-feedback" />
            </div>
            <div class="form-group col">
              <label class="control-label">{{$locales.t("lesson.interaction")}}</label>
              <input type="number" onfocus="this.select();" class="form-control" v-model="model.interactionDegree" 
                :placeholder="$locales.t('lesson.interaction.ph')" min="0" max="99999999" />
              <span data-validation-prop="interactionDegree" 
                data-validation-rule="v => v >= 0 || 'lesson.interaction.invalid'" class="invalid-feedback" />
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
  name: 'SaveStudentLessonModal',
  data: () => ({
    model: {
      id: '', start: '', quizDegree: 0, homeworkDegree: 0, 
      inClassExamDegree: 0, behaviourDegree: 0, interactionDegree: 0, 
      groupId: '', lessonId: '', studentId: '', hasAttend: false, 
      paidAmount: 0, student: null, lesson: null
    },
    students: [],
    studentMissing: false,
    lessons: [],
    lessonMissing: false,
    isEdit: false,
    id: 0,
    dialog: false,
  }),
  computed: {
    title() {
      let option = !this.isEdit ? "options.add" : "options.edit";
      return this.$locales.t(option);
    }, 
    getAttendStaus() {
      return this.$locales.getAttendStaus();
    }
  },
  created() {
    this.$bus.$on("init-save-student-lesson-modal", (studentLesson=null, id=0, groupId='', lesson=null, student=null) => {
      this.students = [];
      this.lessons = [];
      this.studentMissing = this.lessonMissing = false;
      this.model = Object.assign({}, {
        id: '', start: '', quizDegree: 0, homeworkDegree: 0, 
        inClassExamDegree: 0, behaviourDegree: 0, interactionDegree: 0, 
        groupId: groupId, lessonId: lesson?.id ?? '', studentId: student?.id ?? '', 
        hasAttend: false, paidAmount: 0, student: student, lesson: lesson
      });
      if (lesson == null) { this.lessonMissing = true; this.getLessons(groupId); }
      if (student == null) { this.studentMissing = true; this.getStudents(groupId); }
      if (studentLesson != null) {
        Object.assign(this.model, studentLesson);
      }
      this.isEdit = studentLesson != null;
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
    studentChanged() {
      this.model.student = this.students.find(l => l.id == this.model.studentId);
    },
    lessonChanged() {
      this.model.lesson = this.lessons.find(l => l.id == this.model.lessonId);
    },
    getLessons(groupId) {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/lessons`,
        params: {
          queryFilter: `groupId eq ${groupId}`
        }
      }).then(pageData => {
        this.lessons = pageData.data ?? [];
      });
    },
    getStudents(groupId) {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/students`,
        params: {
          queryFilter: `groupIds array_contains ${groupId}`
        }
      }).then(pageData => {
        this.students = pageData.data ?? [];
      });
    },
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
      this.model.start = this.model.lesson.start;

      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/studentlessons${this.isEdit ? `/${this.model.id}`: ''}`,
        method: this.isEdit ? 'PUT' : 'POST',
        data: this.model
      }).then(data => {
        if (!this.isEdit) this.model.id = data;
        this.$bus.$emit("student-lesson-modal-done", this.isEdit, this.id, this.model);
        this.dismiss();
      });
    }
  }
}
</script>

<style scoped>
.margin {
  margin-left: auto !important;
}
</style>