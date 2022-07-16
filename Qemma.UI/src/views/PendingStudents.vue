<template>
  <div class="home">
    <h1 class="mt-2 mb-5">{{$locales.t('students.pending')}}</h1>
    
    <students-table :students="students" />
    <app-pagination :totalCount="count" @changePage="get" :pageSize="pageSize" />

  </div>
</template>

<script>
import StudentsTable from '@/components/StudentsTable.vue'

export default {
  name: 'Home',
  components: { StudentsTable },
  data: () => ({
    students: [],
    count: 0,
    pageSize: 10
  }),
  created() {
    this.$bus.$on("student-modal-done", (isEdit, id, student) => {
      if (isEdit && student.status != 1) {
        this.students.splice(id, 1);
      }
    });
  },
  mounted() {
    this.get();
  },
  methods: {
    get(pageNo=1) {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/students`,
        params: {
          pageNo: pageNo,
          pageSize: this.pageSize,
          queryFilter: "status eq 1"
        }
      }).then(pageData => {
        this.students = pageData.data ?? [];
        this.count = pageData.count;
      });
    }
  }
}
</script>

<style scoped>
.home-title {
  margin-top: 110px;
}
</style>