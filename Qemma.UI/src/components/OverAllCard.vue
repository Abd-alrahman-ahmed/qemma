<template>
  <div class="card border-right-primary shadow h-100 py-2">
    <div class="card-body">
      <div class="row no-gutters align-items-center">
        <div class="col mr-2">
          <template v-for="kv in values">
            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1" :key="'key-' + kv.key">
              {{kv.key}}
            </div>
            <div class="h5 mb-0 font-weight-bold text-gray-800" :key="'value-' + kv.key">{{kv.value}}</div>
          </template>
        </div>
        <div class="col-auto">
          <i :class="icon"></i>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'OverAllCard',
  props: {
    values: {
      type: Array,
      required: true
    },
    icon: {
      type: String,
      required: true
    }
  }
}
</script>

<style>

</style>