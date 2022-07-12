<template>
  <base-modal v-model="dialog" :title="title" modal-size="modal-sm">
    <div slot="body" class="text-center">
      <p>{{$locales.t(message)}}</p>
    </div>
    <div slot="footer">
      <button class="btn btn-danger" @click="confirm">{{$locales.t('modals.confirm.btn')}}</button>
    </div>
  </base-modal>
</template>

<script>
import BaseModal from '@/components/BaseModal.vue'

export default {
  name: 'ConfirmMessageModal',
  components: { BaseModal },
  props: {
    title: String,
    message: String,
    value: Boolean
  },
  data: () => ({
    dialog: false
  }),
  methods: {
    confirm() {
      this.$emit('confirm');
      this.$emit('input', false);
    }
  },
  watch: {
    value: function (newValue, oldValue) {
      this.dialog = newValue;
    },
    dialog: function (newValue, oldValue) {
      this.$emit('input', newValue);
    }
  }
}
</script>

<style>

</style>