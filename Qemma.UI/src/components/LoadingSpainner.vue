<template>
  <div class="container-fluid h-100">
    <div v-if="loading" class="text-center main-overlay">
      <div class="position-fixed-center">
        <div class="spinner-border text-primary" />
        <h2 class="mt-4 text-white">{{$locales.t('app.loading')}}</h2>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LoadingSpainner',
  data: () => ({
    loading: false,
  }),
  created() {
    this.$bus.$on("start-loading", this.startLoading);
    this.$bus.$on("stop-loading", this.stopLoading);
  },
  methods: {
    startLoading() {
      this.loading = true;
    },
    stopLoading() {
      setTimeout(() => {
        this.loading = false;
        this.$bus.$emit("loading-done");
      }, 200)
    }
  }
}
</script>

<style scoped>
.main-overlay {
  position: fixed; /* Stay in place */
  z-index: 1100; /* Sit on top */
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  height: 100%;
  width: 100%;
  transition: .5s ease;
  background-color: rgba(0,0,0,0.6);
  overflow: hidden; /* Disable horizontal scroll */
  transition: 0.5s; /* 0.5 second transition effect to slide in or slide down the overlay (height or width, depending on reveal) */
}
.spinner-border{
  border: .75em solid currentColor;
  border-right-color: transparent;
  border-radius: 50%;
  width: 10rem;
  height: 10rem;
}
.position-fixed-center {
  position: fixed;
  right: 44%;
  bottom: 30%;
}
</style>