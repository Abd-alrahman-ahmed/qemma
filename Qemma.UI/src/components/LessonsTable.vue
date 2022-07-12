<template>
  <div class="table-responsive">
    <table class="table mt-4">
      <thead>
        <tr>
          <th>{{$locales.t('tbls.lessons.cols.name')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.start')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.quiz')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.homework')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.dictation')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.behaviour')}}</th>
          <th>{{$locales.t('tbls.lessons.cols.interaction')}}</th>
          <th ></th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="lessonsCount == 0">
          <td colspan="7"><empty-state /></td>
        </tr>
        <tr v-for="(lesson, index) in lessons" :key="'lesson-' + lesson.id">
          <td>{{lesson.name}}</td>
          <td>{{$moment(lesson.start).local().locale($locales.current).format('MMMM Do dddd YYYY, h:mm:ss a')}}</td>
          <td>{{lesson.quizDegree}}</td>
          <td>{{lesson.homeworkDegree}}</td>
          <td>{{lesson.inClassExamDegree}}</td>
          <td>{{lesson.behaviourDegree}}</td>
          <td>{{lesson.interactionDegree}}</td>
          <td>
            <router-link :to="`/lessons/${lesson.id}`">{{$locales.t('app.options.details')}}</router-link> | 
            <a href="Javascript:void(0);" @click="save(lesson, index)">{{$locales.t('app.options.edit')}}</a> |
            <a href="Javascript:void(0);" @click="remove(lesson.id, index)">{{$locales.t('app.options.delete')}}</a>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'LessonsTable',
  props: {
    lessons: {
      type: Array
    }
  },
  computed: {
    lessonsCount() {
      if (this.lessons == undefined) return 0;
      return this.lessons.length;
    }
  },
  methods: {
    save(lesson, index) {
      this.$bus.$emit("init-save-lesson-modal", lesson, index, lesson.groupId);
    },
    remove(id, index) {
      this.$bus.$emit("init-delete-modal", `lessons/${id}`, index);
    }
  }
}
</script>

<style>

</style>