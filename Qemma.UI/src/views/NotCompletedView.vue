<template>
  <div>
    <warning-sign icon="fas fa-person-digging">
      <span class="mt-5" v-html="$locales.t('app.notcompletedpage')" />
    </warning-sign>
  </div>
</template>

<script>
import WarningSign from '@/components/WarningSign.vue'

export default {
  name: 'NotCompletedView',
  components: {
    WarningSign
  }
}
</script>
