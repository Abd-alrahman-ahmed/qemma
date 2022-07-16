<template>
  <div class="alert alert-success p-0">
    <div data-toggle="collapse" :data-target="'#' + filterId" aria-expanded="false" aria-controls="filter-body" class="filter">
      <font-awesome-icon icon="fas fa-filter" /> {{$locales.t('filter.title')}}
    </div>
    <div class="collapse filter" :id="filterId">
      <button class="btn btn-sm" @click="add">
        <font-awesome-icon icon="fas fa-plus-circle" /> {{$locales.t('filter.add')}}
      </button>
      <template v-for="(filter, index) in filters">
        <div class="form-row" :key="'filter-' + index">
          <div class="form-group col-lg-3 col ">
            <label class="control-label">{{$locales.t('filter.prop')}}</label>
            <v-select :dir="$locales.direction()" :clearable="false" :options="filterProps" :reduce="field => field.value" label="name" 
              v-model="filter.field" :placeholder="$locales.t('filter.prop')" required>
              <template #no-options>
                {{$locales.t("emptystate.default")}}
              </template>
            </v-select>
          </div>
          <div class="form-group col-lg-3 col">
            <label class="control-label">{{$locales.t('filter.operator')}}</label>
            <v-select :dir="$locales.direction()" :clearable="false" :options="fieldOperations(index)" :reduce="operator => operator.value" label="name" 
              v-model="filter.operator" :placeholder="$locales.t('filter.operator')" required>
              <template #no-options>
                {{$locales.t("emptystate.default")}}
              </template>
            </v-select>
          </div>
          <div class="form-group col-lg-4 col">
            <label class="control-label">{{$locales.t('filter.value')}}</label>
            <input v-if="fieldType(index) != 'select'" :dir="$locales.direction()" :placeholder="$locales.t('filter.value')" onfocus="this.select();" class="form-control bg-transparent" 
              required v-model="filter.value" :type="fieldType(index)" />
            <v-select v-else :dir="$locales.direction()" :clearable="false" :options="fieldOptions(index)" :reduce="option => option.id" label="name" 
              v-model="filter.value" :placeholder="$locales.t('filter.value')" required>
              <template #no-options>
                {{$locales.t("emptystate.default")}}
              </template>
            </v-select>
          </div>
          <div class="form-group col-1">
            <button :disabled="filters.length == 1" class="btn btn-sm text-danger mt-4" @click="remove(index)">
              <font-awesome-icon icon="fas fa-trash"/>
            </button>
          </div>
        </div>
        <div v-if="index != filters.length - 1" :key="'sperator-' + index" class="form-row justify-content-center">
          <div class="form-group col-2">
            <v-select :dir="$locales.direction()" :clearable="false" :options="logicalOperators" :reduce="option => option.value" label="name" 
              v-model="logicalOperator" :placeholder="$locales.t('filter.operator')" required />
          </div>
        </div>
      </template>
      <div class="text-right">
        <button class="btn btn-primary btn-sm text-white mx-2" @click="clear">
          <font-awesome-icon icon="fas fa-filter-circle-xmark" /> {{$locales.t('filter.clear')}}
        </button>
        <button class="btn btn-primary btn-sm text-white" @click="apply">
          <font-awesome-icon icon="fas fa-filter" /> {{$locales.t('filter.apply')}}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AppFilter',
  props: {
    filterProps: {
      type: Array
    },
    initFilter: {
      type: Array
    },
    noInitRequest: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    filters: [
      { field: '', operator: '', value: '' }
    ],
    logicalOperator: 'or'
  }),
  computed: {
    filterId() {
      return 'filter-body' + Math.floor(Math.random() * 781293464);
    },
    operators() {
      return [
        { name: this.$locales.t('filter.equal'), value: 'eq' },
        { name: this.$locales.t('filter.notequal'), value: 'neq' },
        { name: this.$locales.t('filter.contains'), value: 'contains' },
        { name: this.$locales.t('filter.greater'), value: 'ge' },
        { name: this.$locales.t('filter.less'), value: 'le' }
      ]
    },
    logicalOperators() {
      return [
        { name: this.$locales.t('filter.or'), value: 'or' },
        { name: this.$locales.t('filter.and'), value: 'and' }
      ]
    }
  },
  created() {
    if (!this.noInitRequest) this.apply();
  },
  methods: {
    fieldType(index) {
      return this.filterProps.find(f => f.value == this.filters[index].field)?.type ?? 'text';
    },
    fieldOperations(index) {
      let allowed = this.filterProps.find(f => f.value == this.filters[index].field)?.operations ?? [];
      return this.operators.filter(o => allowed.some(a => a == o.value));
    },
    fieldOptions(index) {
      return this.filterProps.find(f => f.value == this.filters[index].field)?.options ?? [];
    },
    add() {
      this.filters.push({ field: '', operator: '', value: '' });
    },
    remove(index) {
      this.filters.splice(index, 1);
    },
    apply() {
      let allfilters = [...this.filters];
      if (this.initFilter != undefined) allfilters.push(...this.initFilter);
      let query = '';
      for (let i = 0; i < allfilters.length; i++) {
        let f = allfilters[i];
        if (f.field == '' || f.operator == '') continue;
        query += `${f.field} ${f.operator} ${f.value}`;
        if (i != allfilters.length - 1) query += `;f--${this.logicalOperator}--f;`
      }
      this.$emit('apply', query);
    },
    clear() {
      this.filters = [{ field: '', operator: '', value: '' }];
      this.apply();
    }
  }
}
</script>

<style scoped>
.filter {
  padding: .75rem 1.25rem;
}
</style>