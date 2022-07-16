import Vue from 'vue'
import App from './App.vue'
import LoadingSpainner from '@/components/LoadingSpainner.vue'
import router from './router'
import jQuery from 'jquery'
import moment from 'moment'
import Helper, { HttpService } from './assets/js/helper'
import locales from './locales'

import EmptyState from '@/components/EmptyState.vue'
import AppPagination from '@/components/AppPagination.vue'
import AppFilter from '@/components/AppFilter.vue'

// fontawesome
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { far } from '@fortawesome/free-regular-svg-icons'

/* add icons to the library */
library.add(fas, far)
/* add font awesome icon component */
Vue.component('font-awesome-icon', FontAwesomeIcon)

import vSelect from 'vue-select'
Vue.component('v-select', vSelect)

import VueApexCharts from 'vue-apexcharts'
Vue.use(VueApexCharts)
Vue.component('apexchart', VueApexCharts)

Vue.component('empty-state', EmptyState)
Vue.component('app-pagination', AppPagination)
Vue.component('app-filter', AppFilter)

import 'bootstrap-v4-rtl/dist/css/bootstrap-rtl.min.css'
import 'vue-select/dist/vue-select.css'
import '@/assets/css/app.css'
import 'bootstrap-v4-rtl/dist/js/bootstrap.min.js'

window.$ = jQuery;
Vue.prototype.$bus = new Vue();
Vue.prototype.$http = new HttpService();
Vue.prototype.$helper = new Helper();
Vue.prototype.$moment = moment;
Vue.prototype.$locales = locales;
Vue.config.productionTip = false;

if (process.env.NODE_ENV === 'development'){
  Vue.prototype.$BACKEND_APP_URL = 'https://localhost:44310/api'
} else {
  Vue.prototype.$BACKEND_APP_URL = '/api';
}

Array.prototype.removeIf = function(callback) {
  var i = this.length;
  while (i--) {
      if (callback(this[i], i)) {
          this.splice(i, 1);
      }
  }
};

var loading = new Vue({
  router,
  render: h => h(LoadingSpainner),
}).$mount('#loader');

Vue.prototype.$http.send({
  url: `${Vue.prototype.$BACKEND_APP_URL}/system/locales`
}).then(data => {
  Vue.prototype.$locales.init(data);
  createApp();
}).catch(_ => {
  createApp();
});

function createApp() {
  // destroy the vue listeners, etc
  loading.$destroy();

  // remove the element from the DOM
  loading.$el.parentNode.removeChild(loading.$el);
  new Vue({
    router,
    render: h => h(App)
  }).$mount('#app');
}