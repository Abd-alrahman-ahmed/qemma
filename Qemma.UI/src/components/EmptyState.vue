<template>
  <div class="container">
    <div class="row d-flex justify-content-center">
      <font-awesome-icon icon="fas fa-inbox" class="fa-10x icon-color" />
    </div>
    <br />
    <div class="row d-flex justify-content-center text-center text-color">
      <h2>{{ $locales.t(message) }}</h2>
    </div>
    <br />
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: "EmptyeState",
  props: {
    message: {
      type: String,
      required: false,
      default: 'emptystate.default'
    }
  }
}
</script>

<style scoped>
.text-color {
  color: var(--primary-text);
}
.icon-color {
  color: var(--primary);
}
</style>