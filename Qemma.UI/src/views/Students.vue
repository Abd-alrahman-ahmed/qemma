<template>
  <div class="students">
    <h1 class="mt-2 mb-5">{{$locales.t('views.students.title')}}</h1>
    <button @click="save(null, 0)" class="btn btn-primary btn-sm text-white m-2">
      <font-awesome-icon icon="fas fa-circle-plus"/> {{$locales.t('app.options.add')}}
    </button>
    
    <app-filter :filter-props="filterProps" @apply="applyFilter" />
    <students-table :students="students" />
    <app-pagination :totalCount="count" @changePage="get" :pageSize="pageSize" />

  </div>
</template>

<script>
import StudentsTable from '@/components/StudentsTable.vue'

export default {
  name: 'Students',
  components: { StudentsTable },
  data: () => ({
    students: [],
    count: 0,
    pageSize: 10
  }),
  computed: {
    filterProps() {
      return this.$locales.getStudentFilterProps();
    }
  },
  created() {
    this.$bus.$on("student-modal-done", (isEdit, id, student) => {
      if (!isEdit) this.students.push(student);
      else Object.assign(this.students[id], student);
    });
  },
  methods: {
    get(pageNo=1, filters="") {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/students`,
        params: {
          pageNo: pageNo,
          pageSize: this.pageSize,
          queryFilter: filters
        }
      }).then(pageData => {
        this.students = pageData.data;
        this.count = pageData.count;
      });
    },
    applyFilter(filters) {
      this.get(1, filters)
    },
    save(student, index) {
      this.$bus.$emit("init-save-student-modal", student, index);
    }
  }
}
</script>

<style scoped>
.home-title {
  margin-top: 110px;
}
</style>