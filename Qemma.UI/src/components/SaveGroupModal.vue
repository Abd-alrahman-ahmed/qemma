<template>
  <base-modal v-model="dialog" :title="title" modal-size="modal-md" >
    <base-form slot="body" :model="model" ref="form">
      <div class="row">
        <div class="col-12">
          <div class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("group.year")}}</label>
              <v-select disabled :dir="$locales.direction()" :clearable="false" :options="years" :reduce="year => year.id" label="name" 
                v-model="model.year" :placeholder="$locales.t('group.year.ph')" required>
                <template #no-options>
                  {{$locales.t("emptystate.default")}}
                </template>
              </v-select>
              <span data-validation-prop="year" 
                data-validation-rule="v => v != '' || 'group.year.invalid'" class="invalid-feedback" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col">
              <label class="control-label">{{$locales.t("group.price")}}</label>
              <input type="number" onfocus="this.select();" class="form-control" v-model="model.price" 
                :placeholder="$locales.t('group.price.ph')" />
              <span data-validation-prop="price" 
                data-validation-rule="v => v >= 0 || 'group.price.invalid'" class="invalid-feedback" />
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
  name: 'SaveGroupModal',
  data: () => ({
    model: {
      id: '', name: '', price: 0, year: 0
    },
    isEdit: false,
    id: 0,
    dialog: false,
  }),
  computed: {
    title() {
      let option = !this.isEdit ? "options.add" : "options.edit";
      return this.$locales.t(option);
    },
    years() {
      return this.$locales.getYears();
    }
  },
  created() {
    this.$bus.$on("init-save-group-modal", (group=null, id=0) => {
      this.model = Object.assign({}, {
        name: '', price: 0, year: 0
      });
      if (group != null) {
        Object.assign(this.model, group);
      }
      this.isEdit = group != null;
      this.id = id;
      this.dialog = true;
      this.$refs.form.resetValidation();
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
      this.model.price = parseInt(this.model.price);
      this.model.year = parseInt(this.model.year);
      if(!this.$refs.form.validate()) return;
      this.model.name = this.years.find(y => y.id == this.model.year)?.name ?? "";

      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/groups${this.isEdit ? `/${this.model.id}`: ''}`,
        method: this.isEdit ? 'PUT' : 'POST',
        data: this.model
      }).then(data => {
        if (!this.isEdit) this.model.id = data;
        this.$bus.$emit("group-modal-done", this.isEdit, this.id, this.model);
        this.dismiss();
      });
    }
  }
}
</script>

<style>

</style>