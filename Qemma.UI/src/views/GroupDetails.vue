<template>
  <div class="home">
    <h1 class="mt-2 mb-5">{{$locales.t('views.groupdetails.title')}}</h1>

    <!-- group details -->
    <div class="card mb-2" >
      <div class="row d-flex align-items-center">
        <div class="col-md-2 d-flex justify-content-center">
          <font-awesome-icon icon="fas fa-users-rectangle" class="icon-size" />
        </div>
        <div class="col-md-10">
          <div class="row card-body">
            <div class="col-4">
              <h5 class="card-title" data-toggle="tooltip" data-placement="bottom" :title="$locales.t('tbls.groups.cols.year')">
                {{$locales.t(`lookups.year.${group.year}`)}}
              </h5>
              <h6 class="card-text"> 
                {{$locales.t('tbls.groups.cols.studetsCount')}}: {{studentsCount}}
              </h6>
              <h6 class="card-text"> 
                {{$locales.t('tbls.groups.cols.lessonsCount')}}: {{lessonsCount}}
              </h6>
              <h6 class="card-text">
                {{$locales.t('tbls.groups.cols.price')}}: {{group.price}}
              </h6>
            </div>
            <div class="col-8">
              <a href="Javascript:void(0);" @click="saveGroup">
                <font-awesome-icon icon="fas fa-pen" data-toggle="tooltip" data-placement="bottom" :title="$locales.t('app.options.edit')"/>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
    <hr />
    
    <!-- <h5 class="mt-2 mb-4">{{$locales.t('views.groupdetails.dates')}} 
      <button @click="saveGroupDate(null, 0)" class="btn btn-primary btn-sm text-white m-2">
        <font-awesome-icon icon="fas fa-circle-plus"/> {{$locales.t('app.options.add')}}
      </button>
    </h5>
    <group-dates-table :dates="group.dates" />
    <hr/> -->

    <!-- students -->
    <h5 class="mt-2 mb-4">{{$locales.t('views.students.title')}}</h5>
    <app-filter :init-filter="initStudentFilter" :filter-props="studntFilterProps" @apply="applyStudentFilter" />
    <students-table :students="students" />
    <app-pagination :totalCount="studentsCount" @changePage="getStudents" />
    
    <hr/>
    
    <!-- lessons -->
    <h5 class="mt-2 mb-4">{{$locales.t('views.lessons.title')}}
      <button @click="saveGroupLesson(null, 0)" class="btn btn-primary btn-sm text-white m-2">
        <font-awesome-icon icon="fas fa-circle-plus"/> {{$locales.t('app.options.add')}}
      </button>
    </h5>
    <app-filter :init-filter="initLessonFilter" :filter-props="lessonFilterProps" @apply="applyLessonsFilter" />
    <lessons-table :lessons="lessons" />
    <app-pagination :totalCount="lessonsCount" @changePage="getLessons" />
  </div>
</template>

<script>
import GroupDatesTable from '@/components/GroupDatesTable.vue'
import StudentsTable from '@/components/StudentsTable.vue'
import LessonsTable from '@/components/LessonsTable.vue'

export default {
  name: 'GroupDetails',
  components: { GroupDatesTable, StudentsTable, LessonsTable },
  data: () => ({
    group: {},
    students: [],
    studentsCount: 0,
    lessons: [],
    lessonsCount: 0,
    pageSize: 10
  }),
  computed: {
    studntFilterProps() {
      return this.$locales.getStudentFilterProps();
    },
    initStudentFilter() {
      return [
        { field: 'groupIds', operator: 'array_contains', value: this.$route.params.id }
      ]
    },
    lessonFilterProps() {
      return [
        { name: this.$locales.t('tbls.groups.cols.year'), value: 'year', type: 'select', options: this.$locales.getYears() }
      ]
    },
    initLessonFilter() {
      return [
        { field: 'groupId', operator: 'eq', value: this.$route.params.id }
      ]
    }
  },
  created() {
    this.$bus.$on("group-modal-done", (_, __, group) => {
      this.group = group;
    });

    this.$bus.$on("group-date-modal-done", (isEdit, id, date) => {
      if (group.dates == undefined) group.dates = [];
      if (!isEdit) this.group.dates.push(date);
      else Object.assign(this.group.dates[id], date);
    });
    
    this.$bus.$on("lesson-modal-done", (isEdit, id, lesson) => {
      if (!isEdit) this.lessons.push(lesson);
      else Object.assign(this.lessons[id], lesson);
    });
    
    this.$bus.$on("delete-done", id => {
      this.lessons.splice(id, 1);
    })
  },
  mounted() {
    this.getGroupDetails();
  },
  methods: {
    getGroupDetails() {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/groups/${this.$route.params.id}`,
      }).then(data => {
        this.group = data;
      });
    },
    getStudents(pageNo=1, filters="") {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/students`,
        params: {
          pageNo: pageNo,
          pageSize: this.pageSize,
          queryFilter: filters
        }
      }).then(pageData => {
        this.students = pageData.data;
        this.studentsCount = pageData.count;
      });
    },
    applyStudentFilter(filters) {
      this.getStudents(1, filters)
    },
    getLessons(pageNo=1, filters="") {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/lessons`,
        params: {
          pageNo: pageNo,
          pageSize: this.pageSize,
          queryFilter: filters
        }
      }).then(pageData => {
        this.lessons = pageData.data;
        this.lessonsCount = pageData.count;
      });
    },
    applyLessonsFilter(filters) {
      this.getLessons(1, filters)
    },
    saveGroup() {
      this.$bus.$emit("init-save-group-modal", this.group, 0);
    },
    saveGroupDate(date, index) {
      this.$bus.$emit("init-save-group-date-modal", date, index);
    },
    saveGroupLesson(lesson, index) {
      this.$bus.$emit("init-save-lesson-modal", lesson, index, this.$route.params.id);
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