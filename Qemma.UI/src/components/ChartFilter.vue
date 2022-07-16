<template>
  <div class="alert alert-success p-0">
    <div data-toggle="collapse" :data-target="'#' + filterId" aria-expanded="false" aria-controls="filter-body" class="filter">
      <font-awesome-icon icon="fas fa-filter" /> {{$locales.t('filter.title')}}
    </div>
    <div class="collapse filter" :id="filterId">
      <div class="form-row">
        <div class="form-group col-lg-3 col">
          <label class="control-label">{{$locales.t('filter.from')}}</label>
          <input :dir="$locales.direction()" :placeholder="$locales.t('filter.from')" onfocus="this.select();" 
            class="form-control bg-transparent" required v-model="from" type="date" />
        </div>
        <div class="form-group col-lg-3 col ">
          <label class="control-label">{{$locales.t('filter.to')}}</label>
          <input :dir="$locales.direction()" :placeholder="$locales.t('filter.to')" onfocus="this.select();" 
            class="form-control bg-transparent" required v-model="to" type="date" />
        </div>
        <div class="form-group col-lg-4 col">
          <label class="control-label">{{$locales.t('filter.operator')}}</label>
          <v-select :dir="$locales.direction()" :clearable="false" 
            :options="groupingOptions" :reduce="option => option.id" 
            label="name" v-model="operation" :placeholder="$locales.t('filter.operator')" required>
            <template #no-options>
              {{$locales.t("emptystate.default")}}
            </template>
          </v-select>
        </div>
      </div>
      <div class="text-right">
        <button class="btn btn-primary btn-sm text-white" @click="apply">
          <font-awesome-icon icon="fas fa-filter" /> {{$locales.t('filter.apply')}}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ChartFilter',
  props: {
    groupingOptions: {
      type: Array
    }
  },
  data: () => ({
    from: '',
    to: '',
    operation: 1
  }),
  computed: {
    filterId() {
      return 'chart-filter-body' + Math.floor(Math.random() * 781293464);
    }
  },
  methods: {
    apply() {
      this.$emit('apply', this.from, this.to, this.operation);
    }
  }
}
</script>

<style scoped>
.filter {
  padding: .75rem 1.25rem;
}
</style>