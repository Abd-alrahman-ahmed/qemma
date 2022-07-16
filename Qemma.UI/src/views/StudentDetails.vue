<template>
  <div class="students">
    <h1 class="mt-2 mb-5">{{$locales.t('student.details.title')}}</h1>
    
    <div class="card mb-2" >
      <div class="row d-flex align-items-center">
        <div class="col-md-2 d-flex justify-content-center">
          <div class="avatar">
            <img src="../assets/user.png" class="avatar__letters img-size"/>
          </div>
        </div>
        <div class="col-md-10">
          <div class="row card-body">
            <div class="col-4">
              <h5 class="card-title" data-toggle="tooltip" data-placement="bottom" :title="$locales.t('student.name')">{{student.name}}</h5>
              <h6 class="card-text" data-toggle="tooltip" data-placement="bottom" :title="$locales.t('student.year')">{{$locales.t(`lookups.year.${student.year}`)}}</h6>
              <p class="card-text" data-toggle="tooltip" data-placement="bottom" :title="$locales.t('student.code')">{{student.code}}</p>  
            </div>
            <div class="col-4 card-delimiter">
              <h3 class="card-title" data-toggle="tooltip" data-placement="bottom" :title="$locales.t('student.degree')">{{studentDegreeText}}</h3>
              <h3 class="card-text" data-toggle="tooltip" data-placement="bottom" :title="$locales.t('student.degree')">{{student.totalDegree == 0 ? '--' : studentDegree + '%'}}</h3>
            </div>
            <div class="col-4">
              <a href="Javascript:void(0);" @click="saveStudent">
                <font-awesome-icon icon="fas fa-pen" data-toggle="tooltip" data-placement="bottom" :title="$locales.t('options.edit')"/>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
    <hr />

    <!-- lessons -->
    <h5 class="mt-5 mb-4">{{$locales.t('lessons.title')}}
      <button @click="saveStudentLesson" class="btn btn-primary btn-sm text-white m-2">
        <font-awesome-icon icon="fas fa-circle-plus"/> {{$locales.t('options.add')}}
      </button>
    </h5>
    <app-filter :init-filter="initLessonFilter" :filter-props="lessonFilterProps" @apply="applyLessonsFilter" />
    <student-lessons-table :studentLessons="lessons" student-details />
    <app-pagination :totalCount="lessonsCount" @changePage="getLessons" />
    <hr />
    
    <!-- charts -->
    <h5 class="mt-5 mb-4">{{$locales.t('student.details.charts')}}</h5>
    <chart-filter :grouping-options="chartGroupingOptions" @apply="applyChartFilter" />
    <apexchart v-if="chartHasData" height="400" type="bar" :options="chartOptions" :series="series" />
    <empty-state v-else />
  </div>
</template>

<script>
import StudentLessonsTable from '@/components/StudentLessonsTable.vue'
import ChartFilter from '@/components/ChartFilter.vue'

export default {
  name: 'StudentDetails',
  components: { StudentLessonsTable, ChartFilter },
  data: () => ({
    student: {},
    lessons: [],
    lessonsCount: 0,
    series: [{
      name: '',
      data: []
    }],
    categories: []
  }),
  computed: {
    chartHasData() {
      return this.series && this.series.length > 0 && this.series[0].data && this.series[0].data.length > 0;
    },
    chartOptions() {
      return {
        noData: {
          text: this.$locales.t('emptystate.default'),
          style: {
            fontSize: '32px',
            fontFamily: "'Droid Arabic Kufi', serif",
          }
        },
        chart: {
          id: 'student-degrees',
          toolbar: {
            show: false
          }
        },
        plotOptions: {
          bar: {
            columnWidth: '20%',
            distributed: true,
          }
        },
        legend: {
          show: false
        },
        xaxis: {
          categories: this.categories
        },
        yaxis: {
          min: 0,
          max: 100,
          tickAmount: 10
        },
        tooltip: {
          y: {
            formatter: function(val) {
              return val + '%'
            },
            title: {
              formatter: function (seriesName) {
                return ""
              }
            }
          },
        }
      }
    },
    studentDegree() {
      let degree = this.student.degree / this.student.totalDegree * 100;
      return Math.round(degree * 10) / 10;
    },
    studentDegreeText() {
      return this.$locales.getStudentDegree(this.studentDegree);
    },
    lessonFilterProps() { 
      return this.$locales.getLessonsFilterProps();
    },
    initLessonFilter() {
      return [
         { field: 'studentId', operator: 'eq', value: this.$route.params.id }
      ]
    },
    chartGroupingOptions() {
      return this.$locales.chartGroupingOptions();
    }
  },
  created() {
    this.$bus.$on("student-modal-done", (_, __, student) => {
      this.student = student;
    });

    this.$bus.$on("student-lesson-modal-done", (isEdit, id, studentLesson) => {
      if (!isEdit) this.lessons.push(studentLesson);
      else Object.assign(this.lessons[id], studentLesson);
    });

    this.$bus.$on("delete-done", (id) => {
      this.lessons.splice(id, 1);
    });
  },
  mounted() {
    this.getStudent();
    this.getStudentChart(null, null, 2); // monthly
  },
  methods: {
    getStudent() {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/students/${this.$route.params.id}`
      }).then(data => {
        this.student = data;
      });
    },
    getLessons(pageNo=1, filters="") {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/studentlessons`,
        params: {
          pageNo: pageNo,
          pageSize: this.pageSize,
          orderBy: "start",
          orderDir: "DESC",
          queryFilter: filters
        }
      }).then(pageData => {
        this.lessons = pageData.data ?? [];
        this.lessonsCount = pageData.count;
      });
    },
    applyLessonsFilter(filters) {
      this.getLessons(1, filters)
    },
    saveStudent() {
      this.$bus.$emit("init-save-student-modal", this.student, 0);
    },
    saveStudentLesson() {
      this.$bus.$emit("init-save-student-lesson-modal", null, 0, this.student.groupIds[0], null, this.student);
    },
    getStudentChart(from, to , operation) {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/students/${this.$route.params.id}/chart`,
        params: {
          from: from,
          to: to,
          chartOperator: operation
        }
      }).then(series => {
        this.series = [{
          name: series.name,
          data: series.data
        }];
        let localeCode = this.$locales.getCurrentLocaleCode();
        for (let i = 0; i < series.categories.length; i++){
          if (operation == 1) { // daily
            series.categories[i] = this.$moment(series.categories[i]).local().locale(localeCode).format('MMMM Do dddd YYYY');
          } else { // monthly
            series.categories[i] = this.$moment(series.categories[i]).local().locale(localeCode).format('MMMM YYYY');
          }
        }
        this.categories = series.categories;
      });
    },
    applyChartFilter(from, to , operation) {
      this.getStudentChart(from, to , operation)
    }
  }
}
</script>

<style scoped>
.card-delimiter {
  border-right: 1px solid #000;
  border-left: 0;
}
[dir=ltr] .card-delimiter {
  border-left: 1px solid #000;
  border-right: 0;
}
.img-size{
  height: 150px;
  width: 150px;
}
</style>