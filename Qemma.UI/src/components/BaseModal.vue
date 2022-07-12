<template>
  <div class="modal fade" tabindex="-1" ref="modal-element">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" :class="modalSize">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">{{$locales.t(title)}}</h5>
          <button type="button" class="close" @click="dismiss">
            <span >&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <slot name="body" />
        </div>
        <div class="modal-footer">
          <slot name="footer" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BaseModal',
  props: {
    value: {
      type: Boolean
    },
    title: String,
    'modal-size': {
      type: String,
      default: ''
    }
  },
  methods: {
    dismiss() {
      $(this.$el).modal('hide');
      this.$emit('input', false);
    }
  },
  watch: {
    value: function (newValue, oldValue) {
      if (newValue) {
        $(this.$el).modal({
          backdrop: 'static',
          keyboard: false,
          show: true
        });
      } else {
        this.dismiss();
      }
    }
  }
}
</script>

<style>

</style>