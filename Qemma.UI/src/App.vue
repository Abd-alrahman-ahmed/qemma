<template>
  <div :key="'app-' + rand" id="app" :dir="$locales.direction()">
    <app-title-bar :key="'title-bar-' + rand" />
    <div id="main">
      <app-header :key="'header-' + rand" />
      <div class="container-fluid">
        <div class="row">
          <app-sidebar :key="'sidebar-' + rand" v-if="isLogged" :tabs="sidebar" />
          <main role="main" :class="isLogged ? `col-9 col-lg-10 p-0` : `col-12 p-0`">
            <div class="container-fluid main-div">
              <router-view />
            </div>
            <app-footer :key="'footer-' + rand" />
          </main>
        </div>
      </div>
    </div>
    <loading-spainner :key="'loading-' + rand"/>
    <delete-modal :key="'delete-' + rand"/>
    <save-student-modal :key="'save-student-' + rand" />
    <save-lesson-modal :key="'save-lesson-' + rand"/>
    <save-student-lesson-modal :key="'save-student-lesson-' + rand"/>
  </div>
</template>

<script>
import AppTitleBar from '@/components/AppTitleBar.vue'
import AppSidebar from '@/components/AppSideBar.vue'
import AppFooter from '@/components/AppFooter.vue'
import AppHeader from '@/components/AppHeader.vue'
import LoadingSpainner from '@/components/LoadingSpainner.vue'
import DeleteModal from '@/components/DeleteModal.vue'
import SaveStudentModal from '@/components/SaveStudentModal.vue'
import SaveLessonModal from '@/components/SaveLessonModal.vue'
import SaveStudentLessonModal from '@/components/SaveStudentLessonModal.vue'

export default {
  name: "App",
  components: {
    AppTitleBar,
    AppHeader,
    AppSidebar,
    AppFooter,
    LoadingSpainner,
    DeleteModal,
    SaveStudentModal,
    SaveLessonModal,
    SaveStudentLessonModal
  },
  data: () => ({
    rand: 1,
    isLogged: false,
    sidebar: [
      // {
      //   name: 'home',
      //   action: 'redirect',
      //   to: '/',
      //   icon: 'fas fa-house-user'
      // },
      {
        name: 'students.title',
        icon: 'fas fa-user-graduate',
        children: [
          {
            name: 'students.list',
            action: 'redirect',
            to: '/students',
            icon: 'fas fa-users'
          },
          {
            name: 'students.pending',
            action: 'redirect',
            to: '/students/pending',
            icon: 'fas fa-clock'
          }
        ]
      },
      {
        name: 'groups.title',
        icon: 'fas fa-users',
        action: 'redirect',
        to: '/groups',
        // children: [
        //   {
        //     name: 'groups.list',
        //     action: 'redirect',
        //     to: '/groups',
        //     icon: 'fas fa-users-rectangle'
        //   },
        //   {
        //     name: 'groups.new',
        //     action: 'emit',
        //     to: 'init-save-group-modal',
        //     icon: 'fas fa-users-gear'
        //   } 
        // ]
      },
      {
        name: 'events',
        icon: 'fas fa-calendar-alt',
        action: 'redirect',
        to: '/events',
        // children: [
        //   {
        //     name: 'events.list',
        //     action: 'redirect',
        //     to: '/events',
        //     icon: 'fas fa-calendar-alt'
        //   },
        //   {
        //     name: 'events.new',
        //     action: 'emit',
        //     to: 'init-save-event-modal',
        //     icon: 'fas fa-calendar-plus'
        //   } 
        // ]
      }
    ]
  }),
  created() {
    this.$bus.$on('refresh-app', this.refresh);
    this.isLogged = sessionStorage.getItem(this.$helper.userKey) != null;
    this.$bus.$on('user-log-in', () => {
      this.isLogged = true;
    });
    this.$bus.$on('user-log-out', () => {
      this.isLogged = false;
    });
    this.$locales.setLocale(localStorage.lang || 'ar');
  },
  methods: {
    refresh() {
      this.$locales.setLocale(localStorage.lang || 'ar');
      this.rand = Math.floor(Math.random() * 237859234);
    }
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
