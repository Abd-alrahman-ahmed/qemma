<template>
  <base-modal v-model="dialog" :title="$locales.t('modals.delete.title')" modal-size="modal-sm">
    <div class="row" slot="body">
      <div class="col-12">
        <div class="form-group">
          <label class="control-label">{{$locales.t('modals.delete.msg')}}</label>
          <input onfocus="this.select();" class="form-control" :placeholder="$locales.t('modals.delete.validate.txt')" type="text" v-model="confirm" />
        </div>
      </div>
    </div>
    <button :disabled="confirm != $locales.t('modals.delete.validate.txt')" class="btn btn-danger" @click="save" slot="footer">
      {{$locales.t('modals.confirm.btn')}}
    </button>
  </base-modal>
</template>

<script>
import BaseModal from './BaseModal.vue'

export default {
  name: 'DeleteModal',
  components: { BaseModal },
  data: () => ({
    confirm: '',
    api: '',
    id: '',
    dialog: false
  }),
  created() {
    this.$bus.$on("init-delete-modal", (api, id) => {
      this.confirm = '';
      this.api = api;
      this.id = id;
      this.dialog = true;
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
    save() {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/${this.api}`,
        method: 'DELETE'
      }).then(() => {
        this.confirm = '';
        this.$bus.$emit("delete-done", this.id);
        this.dialog = false;
      });
    }
  }
}
</script>

<style>

</style>