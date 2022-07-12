<template>
  <div class="table-responsive">
    <table class="table mt-4">
      <thead>
        <tr>
          <th>{{$locales.t('tbls.lessons.cols.name')}}</th>
          <th v-if="studentDetails">{{$locales.t('tbls.lessons.cols.start')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.attend')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.quiz')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.homework')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.dictation')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.behaviour')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.interaction')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.paid')}}</th>
          <th ></th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="lessonsCount == 0">
          <td :colspan="studentDetails ? 8 : 7"><empty-state /></td>
        </tr>
        <tr v-for="(studentLesson, index) in studentLessons" :key="'student-lesson-' + studentLesson.id">
          <td>{{studentDetails ? studentLesson.lesson.name : studentLesson.student.name}}</td>
          <td v-if="studentDetails">{{$moment(studentLesson.date).local().locale($locales.current).format('MMMM Do dddd YYYY, h:mm:ss a')}}</td>
          <td>{{$locales.t(`lookups.attend.${studentLesson.hasAttend ? '1' : '2'}`)}}</td>
          <td>{{studentLesson.quizDegree}}/{{studentLesson.lesson.quizDegree}}</td>
          <td>{{studentLesson.homeworkDegree}}/{{studentLesson.lesson.homeworkDegree}}</td>
          <td>{{studentLesson.inClassExamDegree}}/{{studentLesson.lesson.inClassExamDegree}}</td>
          <td>{{studentLesson.behaviourDegree}}/{{studentLesson.lesson.behaviourDegree}}</td>
          <td>{{studentLesson.interactionDegree}}/{{studentLesson.lesson.interactionDegree}}</td>
          <td>{{studentLesson.paidAmount}}</td>
          <td>
            <a href="Javascript:void(0);" @click="save(studentLesson, index)">{{$locales.t('app.options.edit')}}</a> |
            <a href="Javascript:void(0);" @click="remove(studentLesson, index)">{{$locales.t('app.options.delete')}}</a>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'StudentLessonsTable',
  props: {
    studentLessons: {
      type: Array
    },
    studentDetails: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    lessonsCount() {
      if (this.studentLessons == undefined) return 0;
      return this.studentLessons.length;
    }
  },
  methods: {
    save(studentLesson, index) {
      this.$bus.$emit("init-save-student-lesson-modal", studentLesson, index, studentLesson.groupId, studentLesson.lesson, studentLesson.student);
    },
    remove(studentLesson, index) {
      this.$bus.$emit("init-delete-modal", `studentlessons/${studentLesson.id}?studentId=${studentLesson.studentId}&lessonId=${studentLesson.lessonId}`, index);
    }
  }
}
</script>

<style>

</style>