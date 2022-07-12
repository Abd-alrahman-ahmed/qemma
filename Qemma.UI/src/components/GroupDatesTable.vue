<template>
  <div class="table-responsive">
    <table class="table mt-4">
      <thead>
        <tr>
          <th>{{$locales.t('tbls.groupdates.cols.day')}}</th>
          <th>{{$locales.t('tbls.groupdates.cols.starttime')}}</th>
          <th ></th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="datesCount == 0">
          <td colspan="3"><empty-state /></td>
        </tr>
        <tr v-for="(date, index) in dates" :key="'date-' + date.id">
          <td>{{date.day}}</td>
          <td>{{$moment(date.startTime).local().locale($locales.current).format('h:mm:ss a')}}</td>
          <td>
            <a href="Javascript:void(0);" @click="save(date, index)">{{$locales.t('app.options.edit')}}</a>
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