<template>
  <form novalidate :id="Date.now()" v-bind="$attrs">
    <div ref="summary" class="collapse alert alert-danger" role="alert" id="validation-summary">
      <p class="alert-heading">{{$locales.t('forms.invalid.title')}}</p>
      <ul class="validation-error-list">
        <li v-for="(error, index) in errors" class="validation-error" :key="'error-' + index">{{$locales.t(error.message)}}</li>
      </ul>
    </div>
    <slot />
  </form>
</template>

<script>
export default {
  name: 'BaseForm',
  props: {
    model: {
      type: Object,
      required: true
    }
  },
  data: () => ({
    errors: [],
    lastState: '',
    lastAnimation: null
  }),
  created() {
    this.$bus.$on('form-submit-failed', this.afterSubmit);
  },
  mounted() {
    $(this.$refs.summary).on('show.bs.collapse', function () {
      // do something...
    });
    $(this.$refs.summary).on('hide.bs.collapse', function () {
      // do something...
    });
  },
  methods: {
    getter(propStr) {
      let value = this.model;
      let props = propStr.split('.').map(p => p.trim());
      for(let prop of props) {
        if(!value) return null;
        value = value[prop];
      }
      return value;
    },
    showErrors(inputs) {
      this.errors = [];
      let tempErrors = [];
      for (let input of inputs) {
        let prop = $(input).attr('data-validation-prop');
        let rule = $(input).attr('data-validation-rule');
        let id = prop;
        let validator = eval(rule);
        let result = validator(this.getter(prop));
        if (typeof(result) != "string") {
          this.errors.removeIf(e => e.id == id);
          continue;
        }
        if (tempErrors.some(e => e == id)) continue;

        let error = this.errors.find(e => e.id == id);
        if (error == null) {
          tempErrors.push(id);
          error = {
            id: id
          };
          this.errors.push(error);
        }
        error.message = result;
      }
      this.collapseSummary();
    },
    validate() {
      let _inputs = $(`#${this.$el.id}  [data-validation-prop]`);
      this.showErrors(_inputs);
      return this.errors.length == 0;
    },
    resetValidation() {
      this.errors = [];
      this.lastState = '';
      this.lastAnimation = null;
      $(this.$refs.summary).collapse('hide');
    },
    afterSubmit() {
      this.errors = [];
      let _inputs = $(`#${this.$el.id} [data-after-submit-prop]`);
      for (let input of _inputs) {
        let prop = $(input).attr('data-after-submit-prop');
        let message = $(input).attr('data-after-submit-message');
        let error = this.errors.find(e => e.id == prop);
        if (error == null) {
          error = {
            id: prop
          };
          this.errors.push(error);
        }
        error.message = message;
      }
      this.collapseSummary();
    },
    collapseSummary() {
      let state = '';
      if (this.errors.length > 0) {
        state = 'show';
      } else {
        state = 'hide';
      }
      if (this.lastState == state) {
        this.scrollToTop();
        return;
      }
      this.lastState = state;
      if (this.lastAnimation != null) {
        this.lastAnimation.collapse('dispose');
      }
      this.lastAnimation = $(this.$refs.summary).collapse(state);
      if (state == 'show') {
        this.scrollToTop();
      }
    },
    scrollToTop() {
      document.getElementById(this.$el.id).scrollIntoView();
    }
  }
}
</script>

<style>

</style>