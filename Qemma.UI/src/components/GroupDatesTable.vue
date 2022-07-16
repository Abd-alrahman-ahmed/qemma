<template>
  <div class="table-responsive">
    <table class="table mt-4">
      <thead>
        <tr>
          <th>{{$locales.t('group.day')}}</th>
          <th>{{$locales.t('group.starttime')}}</th>
          <th ></th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="datesCount == 0">
          <td colspan="3"><empty-state /></td>
        </tr>
        <tr v-for="(date, index) in dates" :key="'date-' + date.id">
          <td>{{date.day}}</td>
          <td>{{$moment(date.startTime).local().locale($locales.getCurrentLocaleCode()).format('h:mm:ss a')}}</td>
          <td>
            <a href="Javascript:void(0);" @click="save(date, index)">{{$locales.t('options.edit')}}</a>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'GroupDatesTable',
  props: {
    dates: {
      type: Array
    }
  },
  computed: {
    datesCount() {
      if (this.dates == undefined) return 0;
      return this.dates.length;
    }
  },
  methods: {
    save(date, index) {
      this.$bus.$emit("init-save-group-date-modal", date, index);
    }
  }
}
</script>

<style>

</style>