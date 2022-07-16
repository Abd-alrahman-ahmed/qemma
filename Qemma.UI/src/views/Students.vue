<template>
  <div class="students">
    <h1 class="mt-2 mb-5">{{$locales.t('students.title')}}</h1>
    <div class="form-row d-flex justify-content-center">
      <div class="form-group col-6">
        <v-select :dir="$locales.direction()" :clearable="false" :options="students" label="name" 
          v-model="selectedStudent" :placeholder="$locales.t('student.name.ph')" 
          required @option:selected="studentChanged">
          <template #no-options>
            {{$locales.t("emptystate.default")}}
          </template>
        </v-select>
      </div>  
    </div>
    <button @click="save(null, 0)" class="btn btn-primary btn-sm text-white m-2">
      <font-awesome-icon icon="fas fa-circle-plus"/> {{$locales.t('options.add')}}
    </button>
    
    <app-filter :init-filter="initFilter" :filter-props="filterProps" @apply="applyFilter" no-init-request />
    <students-table :students="studentPage"/>
    <app-pagination :totalCount="count" @changePage="getStudentsPage" :pageSize="pageSize" />

  </div>
</template>

<script>
import StudentsTable from '@/components/StudentsTable.vue'

export default {
  name: 'Students',
  components: { StudentsTable },
  data: () => ({
    selectedStudent: null,
    studentPage: [],
    students: [],
    count: 0,
    pageSize: 10,
    filters: "",
    orderBy: "",
    orderDir: ""
  }),
  computed: {
    initFilter() {
      return [
        { field: 'status', operator: 'neq', value: 1 } // exclude pending 
      ]
    },
    filterProps() {
      return this.$locales.getStudentFilterProps();
    }
  },
  created() {
    this.$bus.$on("student-modal-done", (isEdit, id, student) => {
      if (!isEdit) {
        this.students.push(student);
        this.studentPage.push(student);
      }
      else {
        let studentCode = student.id;
        let _studentIndex = this.students.findIndex(s => s.id == studentCode);
        if (student.status == 1) {
          if (_studentIndex != -1) this.students.splice(_studentIndex, 1);
          this.studentPage.splice(id, 1);
        } else {
          if (_studentIndex != -1) {
            Object.assign(this.students[_studentIndex], student);
          }
          Object.assign(this.studentPage[id], student);
        }
      }
    });
    this.get();
  },
  methods: {
    studentChanged() {
      this.router.push('student')
    },
    get() {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/students`,
        params: {
          pageNo: 1,
          pageSize: -1,
          orderBy: "registrationdate",
          queryFilter: "status neq 1"
        }
      }).then(pageData => {
        this.students = pageData.data ?? [];
        this.getStudentsPage(1);
        this.count = pageData.count;
      });
    },
    getStudentsPage(page) {
      this.studentPage = this.students.slice(Math.max(0, page - 1 * this.pageSize), 
          Math.min(page * this.pageSize, this.students.length));
    },
    applyFilter(filters) {
      this.filters = filters;
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/students/filter`,
        method: 'POST',
        params: {
          pageNo: 1,
          pageSize: this.pageSize,
          queryFilter: filters,
          orderBy: "registrationdate"
        },
        data: this.students
      }).then(pageData => {
        this.studentPage = pageData.data ?? [];
      });
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