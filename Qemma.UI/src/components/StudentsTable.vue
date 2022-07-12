<template>
  <div class="table-responsive">
    <table class="table mt-4">
      <thead>
        <tr>
          <th>{{$locales.t('tbls.students.cols.code')}}</th>
          <th>{{$locales.t('tbls.students.cols.registrationdate')}}</th>
          <th>{{$locales.t('tbls.students.cols.name')}}</th>
          <th>{{$locales.t('tbls.students.cols.gender')}}</th>
          <th>{{$locales.t('tbls.students.cols.year')}}</th>
          <th>{{$locales.t('tbls.students.cols.degree')}}</th>
          <th>{{$locales.t('tbls.students.cols.status')}}</th>
          <th ></th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="studentsCount == 0">
          <td colspan="8"><empty-state /></td>
        </tr>
        <tr v-for="(student, index) in students" :key="'student-' + student.id">
          <td>{{student.id}}</td>
          <td>{{$moment(student.regisrationDate).local().locale($locales.current).format('MMMM Do dddd YYYY, h:mm:ss a')}}</td>
          <td>{{student.name}}</td>
          <td>{{$locales.t(`lookups.gender.${student.gender}`)}}</td>
          <td>{{$locales.t(`lookups.year.${student.year}`)}}</td>
          <td>{{student.degree / student.degree * 100}}%</td>
          <td data-toggle="tooltip" data-placement="bottom" :title="$locales.t(`lookups.status.${student.status}`)">
            <font-awesome-icon :icon="getStatusIcon(student)" :class="getStatusColor(student)" />
          </td>
          <td>
            <router-link :to="`/students/${student.id}`">{{$locales.t('app.options.details')}}</router-link> | 
            <a href="Javascript:void(0);" @click="save(student, index)">{{$locales.t('app.options.edit')}}</a>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'StudentTable',
  props: {
    students: {
      type: Array
    }
  },
  computed: {
    studentsCount() {
      if (this.students == undefined) return 0;
      return this.students.length;
    }
  },
  methods: {
    getStatusIcon(student) {
      if (student.status == 1) { // pending
        return 'fas fa-clock';
      } else if (student.status == 2) { // confirmed
        return 'fas fa-circle-check';
      } else { // blocked
        return 'fas fa-ban';
      }
    },
    getStatusColor(student) {
      if (student.status == 1) { // pending
        return 'text-dark';
      } else if (student.status == 2) { // confirmed
        return 'text-success';
      } else { // blocked
        return 'text-danger';
      }
    },
    save(student, index) {
      this.$bus.$emit("init-save-student-modal", student, index);
    }
  }
}
</script>

<style>

</style>