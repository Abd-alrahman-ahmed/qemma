<template>
  <div id="app" :dir="$locales.direction()">
    <app-title-bar />
    <div id="main">
      <app-header />
      <div class="container-fluid">
        <div class="row">
          <app-side-bar v-if="isLogged" :tabs="sidebar" />
          <main role="main" :class="isLogged ? `col-9 col-lg-10 p-0` : `col-12 p-0`">
            <div class="container-fluid main-div">
              <router-view />
            </div>
            <app-footer />
          </main>
        </div>
      </div>
    </div>
    <loading-spainner />
    <delete-modal />
    <save-student-modal />
    <save-group-modal />
    <save-lesson-modal />
    <save-student-lesson-modal />
  </div>
</template>

<script>
import AppTitleBar from '@/components/AppTitleBar.vue'
import AppSideBar from '@/components/AppSideBar.vue'
import AppFooter from '@/components/AppFooter.vue'
import AppHeader from '@/components/AppHeader.vue'
import LoadingSpainner from '@/components/LoadingSpainner.vue'
import DeleteModal from '@/components/DeleteModal.vue'
import SaveStudentModal from '@/components/SaveStudentModal.vue'
import SaveGroupModal from '@/components/SaveGroupModal.vue'
import SaveLessonModal from '@/components/SaveLessonModal.vue'
import SaveStudentLessonModal from '@/components/SaveStudentLessonModal.vue'

export default {
  name: "App",
  components: {
    AppTitleBar,
    AppHeader,
    AppSideBar,
    AppFooter,
    LoadingSpainner,
    DeleteModal,
    SaveStudentModal,
    SaveGroupModal,
    SaveLessonModal,
    SaveStudentLessonModal
  },
  data: () => ({
    isLogged: false,
    sidebar: [
      {
        name: 'tabs.home',
        action: 'redirect',
        to: '/',
        icon: 'fas fa-house-user'
      },
      {
        name: 'tabs.students',
        icon: 'fas fa-user-graduate',
        children: [
          {
            name: 'tabs.students.list',
            action: 'redirect',
            to: '/students',
            icon: 'fas fa-users'
          },
          {
            name: 'tabs.students.new',
            action: 'emit',
            to: 'init-save-student-modal',
            icon: 'fas fa-user-plus'
          }
        ]
      },
      {
        name: 'tabs.groups',
        icon: 'fas fa-users',
        action: 'redirect',
        to: '/groups',
        // children: [
        //   {
        //     name: 'tabs.groups.list',
        //     action: 'redirect',
        //     to: '/groups',
        //     icon: 'fas fa-users-rectangle'
        //   },
        //   {
        //     name: 'tabs.groups.new',
        //     action: 'emit',
        //     to: 'init-save-group-modal',
        //     icon: 'fas fa-users-gear'
        //   } 
        // ]
      },
      {
        name: 'tabs.events',
        icon: 'fas fa-calendar-alt',
        action: 'redirect',
        to: '/events',
        // children: [
        //   {
        //     name: 'tabs.events.list',
        //     action: 'redirect',
        //     to: '/events',
        //     icon: 'fas fa-calendar-alt'
        //   },
        //   {
        //     name: 'tabs.events.new',
        //     action: 'emit',
        //     to: 'init-save-event-modal',
        //     icon: 'fas fa-calendar-plus'
        //   } 
        // ]
      }
    ]
  }),
  created() {
    this.isLogged = sessionStorage.getItem(this.$helper.userKey) != null;
    this.$bus.$on('user-log-in', () => {
      this.isLogged = true;
    });
    this.$bus.$on('user-log-out', () => {
      this.isLogged = false;
    });
    this.$locales.setLocale(localStorage.lang || 'ar');
  }
}
</script>

<style>
#app {
  color: var(--primary-text);
  overflow-y: hidden;
}
.main-div {
  height: calc(100vh - 100px);
  overflow-y: scroll;
}
#main {
  height: calc(100% - 32px);
  margin-top: 32px;
  overflow-y: hidden;
}
</style>
