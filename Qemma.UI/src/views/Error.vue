<template>
  <div class="fill-height">
    <warning-sign>
      <div class="text-white">
        <h1 class="mt-3">{{errorCode}}</h1>
        <span v-html="errorMessage" />
      </div>
    </warning-sign>
  </div>
</template>

<script>
import WarningSign from '@/components/WarningSign.vue'

export default {
  name: 'Error',
  components: { WarningSign },
  computed: {
    errorCode() {
      return this.$route.meta.errorCode;
    },
    errorMessage() {
      switch(this.errorCode){
        case 404:
          return 'عذراً لم نجد ما تبحث عنه';
        case 500:
          return `نأسف لما حدث هذا خطأنا من فضلك تواصل معنا للدعم
          <br />
          رقم الهاتف: <b>01026360473</b>
          <br />
          البريد الإلكتروني: <b>abdalrahmana574@gmail.com</b>`;
      }
    }
  }
}
</script>

<style scoped>
</style>