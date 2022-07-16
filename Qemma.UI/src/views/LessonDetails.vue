<template>
  <div class="students">
    <h1 class="mt-2 mb-5">{{$locales.t('lesson.details.title')}}</h1>

    <!-- lesson details -->
    <div class="card mb-2" >
      <div class="row d-flex align-items-center">
        <div class="col-md-2 d-flex justify-content-center">
          <font-awesome-icon icon="fas fa-school" class="icon-size" />
        </div>
        <div class="col-md-10">
          <div class="row card-body">
            <div class="col-4">
              <h5 class="card-title" data-toggle="tooltip" data-placement="bottom" :title="$locales.t('lesson.name')">
                {{lesson.name}}
              </h5>
              <h6 class="card-text" data-toggle="tooltip" data-placement="bottom" :title="$locales.t('lesson.start')">
                {{$moment(lesson.start).local().locale($locales.getCurrentLocaleCode()).format('MMMM Do dddd YYYY, h:mm:ss a')}}
              </h6>
            </div>
            <div class="col-6">
              <a href="Javascript:void(0);" @click="saveLesson">
                <font-awesome-icon icon="fas fa-pen" data-toggle="tooltip" data-placement="bottom" :title="$locales.t('options.edit')"/>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
    <hr />
    
    <h5 class="mt-2 mb-4">
      {{$locales.t('students.title')}}
      <button @click="save(null, 0)" class="btn btn-primary btn-sm text-white m-2">
        <font-awesome-icon icon="fas fa-circle-plus"/> {{$locales.t('options.add')}}
      </button>
    </h5>
    <app-filter :init-filter="initFilter" :filter-props="filterProps" @apply="applyFilter" />
    <student-lessons-table :studentLessons="studentLessons"/>
    <app-pagination :totalCount="count" @changePage="getStudentLessons" :pageSize="pageSize" />

  </div>
</template>

<script>
import StudentLessonsTable from '@/components/StudentLessonsTable.vue'

export default {
  name: 'LessonDetails',
  components: { StudentLessonsTable },
  data: () => ({
    lesson: {},
    studentLessons: [],
    count: 0,
    pageSize: 5
  }),
  computed: {
    filterProps() {
      return [

      ];
    },
    initFilter() {
      return [
         { field: 'lessonId', operator: 'eq', value: this.$route.params.id }
      ];
    }
  },
  created() {
    this.$bus.$on("student-lesson-modal-done", (isEdit, id, studentLesson) => {
      if (!isEdit) this.studentLessons.push(studentLesson);
      else Object.assign(this.studentLessons[id], studentLesson);
    });

    this.$bus.$on("delete-done", (id) => {
      this.studentLessons.splice(id, 1);
    });
  },
  mounted() {
    this.getLesson();
  },
  methods: {
    getLesson() {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/lessons/${this.$route.params.id}`,
      }).then(data => {
        this.lesson = data;
      });
    },
    saveLesson() {
      this.$bus.$emit("init-save-lesson-modal", this.lesson, 0, this.lesson.groupId);
    },
    getStudentLessons(pageNo=1, filter="") {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/studentlessons`,
        params: {
          pageNo: pageNo,
          pageSize: this.pageSize,
          queryFilter: filter
        }
      }).then(pageData => {
        this.studentLessons = pageData.data ?? [];
        this.count = pageData.count;
      });
    },
    applyFilter(filter) {
      this.getStudentLessons(1, filter)
    },
    save(studentLesson, index) {
      this.$bus.$emit("init-save-student-lesson-modal", studentLesson, index, this.lesson.groupId, this.lesson, null);
    }
  }
}
</script>

<style scoped>
.icon-size{
  font-size: 100px;
  color: var(--primary);
}
</style>