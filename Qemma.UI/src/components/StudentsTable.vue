<template>
  <div class="table-responsive">
    <table class="table mt-4 sortable">
      <thead>
        <tr>
          <th>{{$locales.t('student.code')}}</th>
          <th>{{$locales.t('student.registrationdate')}}</th>
          <th>{{$locales.t('student.name')}}</th>
          <th>{{$locales.t('student.gender')}}</th>
          <th>{{$locales.t('student.year')}}</th>
          <th>{{$locales.t('student.degree')}}</th>
          <th>{{$locales.t('student.status')}}</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="studentsCount == 0">
          <td colspan="8"><empty-state /></td>
        </tr>
        <tr v-for="(student, index) in students" :key="'student-' + student.id">
          <td>{{student.code}}</td>
          <td>{{$moment(student.regisrationDate).local().locale($locales.getCurrentLocaleCode()).format('MMMM Do dddd YYYY, h:mm:ss a')}}</td>
          <td>{{student.name}}</td>
          <td>{{$locales.t(`lookups.gender.${student.gender}`)}}</td>
          <td>{{$locales.t(`lookups.year.${student.year}`)}}</td>
          <td>{{student.totalDegree == 0 ? '--' : Math.round(student.degree / student.totalDegree * 1000) / 10 + '%'}}</td>
          <td data-toggle="tooltip" data-placement="bottom" :title="$locales.t(`lookups.status.${student.status}`)">
            <font-awesome-icon :icon="getStatusIcon(student)" :class="getStatusColor(student)" />
          </td>
          <td>
            <router-link :to="`/students/${student.id}`">{{$locales.t('options.details')}}</router-link> | 
            <a href="Javascript:void(0);" @click="save(student, index)">{{$locales.t('options.edit')}}</a>
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
.pointer.desc:after {
  content: "▲";
}
.pointer.asc:after {
  content: "▼";
}
</style>