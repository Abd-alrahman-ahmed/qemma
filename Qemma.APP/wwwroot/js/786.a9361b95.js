"use strict";(global["webpackChunkal_qemma"]=global["webpackChunkal_qemma"]||[]).push([[786],{7786:(t,s,e)=>{e.r(s),e.d(s,{default:()=>y});var a=function(){var t=this,s=t.$createElement,e=t._self._c||s;return e("div",{staticClass:"home"},[e("h1",{staticClass:"mt-2 mb-5"},[t._v(t._s(t.$locales.t("group.details.title")))]),e("div",{staticClass:"card mb-2"},[e("div",{staticClass:"row d-flex align-items-center"},[e("div",{staticClass:"col-md-2 d-flex justify-content-center"},[e("font-awesome-icon",{staticClass:"icon-size",attrs:{icon:"fas fa-users-rectangle"}})],1),e("div",{staticClass:"col-md-10"},[e("div",{staticClass:"row card-body"},[e("div",{staticClass:"col-6"},[e("h5",{staticClass:"card-title",attrs:{"data-toggle":"tooltip","data-placement":"bottom",title:t.$locales.t("group.year")}},[t._v(" "+t._s(t.$locales.t("lookups.year."+t.group.year))+" ")]),e("h6",{staticClass:"card-text"},[t._v(" "+t._s(t.$locales.t("group.studetsCount"))+": "+t._s(t.studentsCount)+" ")]),e("h6",{staticClass:"card-text"},[t._v(" "+t._s(t.$locales.t("group.lessonsCount"))+": "+t._s(t.lessonsCount)+" ")])])])])])]),e("hr"),e("h5",{staticClass:"mt-2 mb-4"},[t._v(t._s(t.$locales.t("students.title")))]),e("app-filter",{attrs:{"init-filter":t.initStudentFilter,"filter-props":t.studntFilterProps},on:{apply:t.applyStudentFilter}}),e("students-table",{attrs:{students:t.students}}),e("app-pagination",{attrs:{totalCount:t.studentsCount},on:{changePage:t.getStudents}}),e("hr"),e("h5",{staticClass:"mt-2 mb-4"},[t._v(t._s(t.$locales.t("lessons.title"))+" "),e("button",{staticClass:"btn btn-primary btn-sm text-white m-2",on:{click:function(s){return t.saveGroupLesson(null,0)}}},[e("font-awesome-icon",{attrs:{icon:"fas fa-circle-plus"}}),t._v(" "+t._s(t.$locales.t("options.add"))+" ")],1)]),e("app-filter",{attrs:{"init-filter":t.initLessonFilter,"filter-props":t.lessonFilterProps},on:{apply:t.applyLessonsFilter}}),e("lessons-table",{attrs:{lessons:t.lessons}}),e("app-pagination",{attrs:{totalCount:t.lessonsCount},on:{changePage:t.getLessons}})],1)},o=[],l=function(){var t=this,s=t.$createElement,e=t._self._c||s;return e("div",{staticClass:"table-responsive"},[e("table",{staticClass:"table mt-4"},[e("thead",[e("tr",[e("th",[t._v(t._s(t.$locales.t("group.day")))]),e("th",[t._v(t._s(t.$locales.t("group.starttime")))]),e("th")])]),e("tbody",[0==t.datesCount?e("tr",[e("td",{attrs:{colspan:"3"}},[e("empty-state")],1)]):t._e(),t._l(t.dates,(function(s,a){return e("tr",{key:"date-"+s.id},[e("td",[t._v(t._s(s.day))]),e("td",[t._v(t._s(t.$moment(s.startTime).local().locale(t.$locales.getCurrentLocaleCode()).format("h:mm:ss a")))]),e("td",[e("a",{attrs:{href:"Javascript:void(0);"},on:{click:function(e){return t.save(s,a)}}},[t._v(t._s(t.$locales.t("options.edit")))])])])}))],2)])])},n=[];const i={name:"GroupDatesTable",props:{dates:{type:Array}},computed:{datesCount(){return void 0==this.dates?0:this.dates.length}},methods:{save(t,s){this.$bus.$emit("init-save-group-date-modal",t,s)}}},r=i;var u=e(1001),d=(0,u.Z)(r,l,n,!1,null,null,null);const c=d.exports;var p=e(8497),h=function(){var t=this,s=t.$createElement,e=t._self._c||s;return e("div",{staticClass:"table-responsive"},[e("table",{staticClass:"table mt-4"},[e("thead",[e("tr",[e("th",[t._v(t._s(t.$locales.t("lesson.name")))]),e("th",[t._v(t._s(t.$locales.t("lesson.start")))]),e("th",[t._v(t._s(t.$locales.t("lesson.quiz")))]),e("th",[t._v(t._s(t.$locales.t("lesson.homework")))]),e("th",[t._v(t._s(t.$locales.t("lesson.dictation")))]),e("th",[t._v(t._s(t.$locales.t("lesson.behaviour")))]),e("th",[t._v(t._s(t.$locales.t("lesson.interaction")))]),e("th")])]),e("tbody",[0==t.lessonsCount?e("tr",[e("td",{attrs:{colspan:"7"}},[e("empty-state")],1)]):t._e(),t._l(t.lessons,(function(s,a){return e("tr",{key:"lesson-"+s.id},[e("td",[t._v(t._s(s.name))]),e("td",[t._v(t._s(t.$moment(s.start).local().locale(t.$locales.getCurrentLocaleCode()).format("MMMM Do dddd YYYY, h:mm:ss a")))]),e("td",[t._v(t._s(s.quizDegree))]),e("td",[t._v(t._s(s.homeworkDegree))]),e("td",[t._v(t._s(s.inClassExamDegree))]),e("td",[t._v(t._s(s.behaviourDegree))]),e("td",[t._v(t._s(s.interactionDegree))]),e("td",[e("router-link",{attrs:{to:"/lessons/"+s.id}},[t._v(t._s(t.$locales.t("options.details")))]),t._v(" | "),e("a",{attrs:{href:"Javascript:void(0);"},on:{click:function(e){return t.save(s,a)}}},[t._v(t._s(t.$locales.t("options.edit")))]),t._v(" | "),e("a",{attrs:{href:"Javascript:void(0);"},on:{click:function(e){return t.remove(s.id,a)}}},[t._v(t._s(t.$locales.t("options.delete")))])],1)])}))],2)])])},_=[];const m={name:"LessonsTable",props:{lessons:{type:Array}},computed:{lessonsCount(){return void 0==this.lessons?0:this.lessons.length}},methods:{save(t,s){this.$bus.$emit("init-save-lesson-modal",t,s,t.groupId)},remove(t,s){this.$bus.$emit("init-delete-modal",`lessons/${t}`,s)}}},v=m;var $=(0,u.Z)(v,h,_,!1,null,null,null);const g=$.exports,C={name:"GroupDetails",components:{GroupDatesTable:c,StudentsTable:p.Z,LessonsTable:g},data:()=>({group:{},students:[],studentsCount:0,lessons:[],lessonsCount:0,pageSize:10}),computed:{studntFilterProps(){return this.$locales.getStudentFilterProps()},initStudentFilter(){return[{field:"groupIds",operator:"array_contains",value:this.$route.params.id}]},lessonFilterProps(){return this.$locales.getLessonsFilterProps()},initLessonFilter(){return[{field:"groupId",operator:"eq",value:this.$route.params.id}]}},created(){this.$bus.$on("group-modal-done",((t,s,e)=>{this.group=e})),this.$bus.$on("group-date-modal-done",((t,s,e)=>{void 0==group.dates&&(group.dates=[]),t?Object.assign(this.group.dates[s],e):this.group.dates.push(e)})),this.$bus.$on("lesson-modal-done",((t,s,e)=>{t?Object.assign(this.lessons[s],e):this.lessons.push(e)})),this.$bus.$on("delete-done",(t=>{this.lessons.splice(t,1)}))},mounted(){this.getGroupDetails()},methods:{getGroupDetails(){this.$http.send({url:`${this.$BACKEND_APP_URL}/groups/${this.$route.params.id}`}).then((t=>{this.group=t}))},getStudents(t=1,s=""){this.$http.send({url:`${this.$BACKEND_APP_URL}/students`,params:{pageNo:t,pageSize:this.pageSize,queryFilter:s}}).then((t=>{this.students=t.data??[],this.studentsCount=t.count}))},applyStudentFilter(t){this.getStudents(1,t)},getLessons(t=1,s=""){this.$http.send({url:`${this.$BACKEND_APP_URL}/lessons`,params:{pageNo:t,pageSize:this.pageSize,queryFilter:s}}).then((t=>{this.lessons=t.data??[],this.lessonsCount=t.count}))},applyLessonsFilter(t){this.getLessons(1,t)},saveGroup(){this.$bus.$emit("init-save-group-modal",this.group,0)},saveGroupDate(t,s){this.$bus.$emit("init-save-group-date-modal",t,s)},saveGroupLesson(t,s){this.$bus.$emit("init-save-lesson-modal",t,s,this.$route.params.id)}}},b=C;var f=(0,u.Z)(b,a,o,!1,null,"c83ec93c",null);const y=f.exports}}]);
//# sourceMappingURL=786.a9361b95.js.map