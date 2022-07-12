<template>
  <base-modal v-model="dialog" :title="title" modal-size="modal-md">
    <base-form slot="body" :model="model" ref="form">
      <div class="row">
        <div class="col-12">
          <div class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("forms.students.name")}}</label>
              <input onfocus="this.select();" class="form-control" v-model="model.name" :placeholder="$locales.t('forms.students.name.ph')" />
              <span data-validation-prop="name" 
                data-validation-rule="v => v != '' || 'forms.students.name.invalid'" class="invalid-feedback" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("forms.students.gender")}}</label>
              <v-select :dir="$locales.direction()" :clearable="false" :options="genders" :reduce="gender => gender.id" label="name" 
                v-model="model.gender" :placeholder="$locales.t('forms.students.gender.ph')" required>
                <template #no-options>
                  {{$locales.t("app.emptystate.default")}}
                </template>
              </v-select>
              <span data-validation-prop="gender" 
                data-validation-rule="v => v != '' || 'forms.students.gender.invalid'" class="invalid-feedback" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("forms.students.year")}}</label>
              <v-select :dir="$locales.direction()" :clearable="false" :options="years" :reduce="year => year.id" label="name" 
                v-model="model.year" :placeholder="$locales.t('forms.students.year.ph')" required>
                <template #no-options>
                  {{$locales.t("app.emptystate.default")}}
                </template>
              </v-select>
              <span data-validation-prop="year" 
                data-validation-rule="v => v != '' || 'forms.students.year.invalid'" class="invalid-feedback" />
            </div>
          </div>
          <div v-if="isEdit" class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("forms.students.status")}}</label>
              <v-select :dir="$locales.direction()" :clearable="false" :options="status" :reduce="status => status.id" label="name" 
                v-model="model.status" :placeholder="$locales.t('forms.students.status.ph')" required>
                <template #no-options>
                  {{$locales.t("app.emptystate.default")}}
                </template>
              </v-select>
              <span data-validation-prop="status" 
                data-validation-rule="v => v != '' || 'forms.students.status.invalid'" class="invalid-feedback" />
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
  name: 'SaveStudentModal',
  data: () => ({
    model: {
      id: '', name: '', gender: 0, year: 0, status: 0
    },
    isEdit: false,
    id: 0,
    dialog: false,
  }),
  computed: {
    title() {
      let option = !this.isEdit ? "app.options.add" : "app.options.edit";
      return this.$locales.t(option);
    },
    genders() {
      return this.$locales.getGenders();
    },
    years() {
      return this.$locales.getYears();
    },
    status() {
      return this.$locales.getStatus();
    }
  },
  created() {
    this.$bus.$on("init-save-student-modal", (student=null, id=0) => {
      this.model = Object.assign({}, {
        name: '', gender: 0, year: 0, status: 0
      });
      if (student != null) {
        Object.assign(this.model, student);
      }
      this.isEdit = student != null;
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
      this.model.gender = parseInt(this.model.gender);
      this.model.year = parseInt(this.model.year);
      if(!this.$refs.form.validate()) return;

      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/students${this.isEdit ? `/${this.model.id}`: ''}`,
        method: this.isEdit ? 'PUT' : 'POST',
        data: this.model
      }).then(data => {
        if (!this.isEdit) {
          this.model.id = data;
          this.model.status = 2; // confirmed
        };
        this.$refs.form.resetValidation();
        this.$bus.$emit("student-modal-done", this.isEdit, this.id, this.model);
        this.dismiss();
      });
    }
  }
}
</script>

<style>

</style>