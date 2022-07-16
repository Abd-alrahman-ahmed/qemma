<template>
  <div class="table-responsive">
    <table class="table mt-4">
      <thead>
        <tr>
          <th>{{$locales.t('lesson.name')}}</th>
          <th v-if="studentDetails">{{$locales.t('lesson.start')}}</th>
          <th>{{$locales.t('lesson.attend')}}</th>
          <th>{{$locales.t('lesson.quiz')}}</th>
          <th>{{$locales.t('lesson.homework')}}</th>
          <th>{{$locales.t('lesson.dictation')}}</th>
          <th>{{$locales.t('lesson.behaviour')}}</th>
          <th>{{$locales.t('lesson.interaction')}}</th>
          <th>{{$locales.t('lesson.paid')}}</th>
          <th ></th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="lessonsCount == 0">
          <td :colspan="studentDetails ? 8 : 7"><empty-state /></td>
        </tr>
        <tr v-for="(studentLesson, index) in studentLessons" :key="'student-lesson-' + studentLesson.id">
          <td>{{studentDetails ? studentLesson.lesson.name : studentLesson.student.name}}</td>
          <td v-if="studentDetails">{{$moment(studentLesson.date).local().locale($locales.getCurrentLocaleCode()).format('MMMM Do dddd YYYY, h:mm:ss a')}}</td>
          <td>{{$locales.t(`lookups.attend.${studentLesson.hasAttend ? '1' : '2'}`)}}</td>
          <td>{{studentLesson.quizDegree}}/{{studentLesson.lesson.quizDegree}}</td>
          <td>{{studentLesson.homeworkDegree}}/{{studentLesson.lesson.homeworkDegree}}</td>
          <td>{{studentLesson.inClassExamDegree}}/{{studentLesson.lesson.inClassExamDegree}}</td>
          <td>{{studentLesson.behaviourDegree}}/{{studentLesson.lesson.behaviourDegree}}</td>
          <td>{{studentLesson.interactionDegree}}/{{studentLesson.lesson.interactionDegree}}</td>
          <td>{{studentLesson.paidAmount}}</td>
          <td>
            <a href="Javascript:void(0);" @click="save(studentLesson, index)">{{$locales.t('options.edit')}}</a> |
            <a href="Javascript:void(0);" @click="remove(studentLesson, index)">{{$locales.t('options.delete')}}</a>
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