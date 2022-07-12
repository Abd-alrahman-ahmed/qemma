import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'main',
    component: Home
  },
  {
    path: '/home',
    name: 'home',
    component: Home
  },
  {
    path: '/signin',
    name: 'sign-in',
    component: () => import('../views/SignIn.vue')
  },
  {
    path: '/students',
    name: 'students',
    component: () => import('../views/Students.vue')
  },
  {
    path: '/students/:id',
    name: 'student-details',
    component: () => import('../views/StudentDetails.vue')
  },
  {
    path: '/groups',
    name: 'groups',
    component: () => import('../views/Groups.vue')
  },
  {
    path: '/groups/:id',
    name: 'group-details',
    component: () => import('../views/GroupDetails.vue')
  },
  {
    path: '/lessons/:id',
    name: 'lesson-details',
    component: () => import('../views/LessonDetails.vue')
  },
  {
    path: '/events',
    name: 'events',
    component: () => import('../views/NotCompletedView.vue')
  },
  {
    path: '/500',
    name: 'internal-error',
    meta: {
      errorCode: 500
    },
    component: () => import('../views/Error.vue')
  },
  {
    path: '/404',
    name: 'not-found',
    meta: {
      errorCode: 404
    },
    component: () => import('../views/Error.vue')
  },
  {
    path: '*',
    name: 'not-found-default-route',
    meta: {
      errorCode: 404
    },
    component: () => import('../views/Error.vue')
  }

]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach((to, from, next) => {
  if (to.name !== 'sign-in' && sessionStorage.getItem('user') == undefined) next({ name: 'sign-in' })
  else next()
})

export default router
