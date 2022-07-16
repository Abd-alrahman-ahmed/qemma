<template>
  <div class="home">
    <h1 class="mt-2 mb-5">{{$locales.t('groups.title')}}</h1>
    <!-- <button @click="save(null, 0)" class="btn btn-primary btn-sm text-white m-2">
      <font-awesome-icon icon="fas fa-circle-plus"/> {{$locales.t('options.add')}}
    </button> -->

    <app-filter :filter-props="filterProps" @apply="applyFilter" />
    <div class="table-responsive mt-4">
      <table class="table">
        <thead>
          <tr>
            <th>{{$locales.t('group.year')}}</th>
            <th>{{$locales.t('group.studetsCount')}}</th>
            <th ></th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="groups.length == 0">
            <td colspan="4"><empty-state /></td>
          </tr>
          <tr v-for="group in groups" :key="'group-' + group.id">
            <td>{{$locales.t(`lookups.year.${group.year}`)}}</td>
            <td>{{studentCount(group.studentIds)}}</td>
            <td>
              <router-link :to="`/groups/${group.id}`">{{$locales.t('options.details')}}</router-link>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- <app-pagination :totalCount="count" @changePage="get" /> -->

  </div>
</template>

<script>
export default {
  name: 'Groups',
  data: () => ({
    groups: [],
    count: 0,
    pageSize: -1
  }),
  created() {
    this.$bus.$on("group-modal-done", (isEdit, id, group) => {
      if (!isEdit) this.groups.push(group);
      else Object.assign(this.groups[id], group);
    });
  },
  computed: {
    filterProps() {
      return [
        { name: this.$locales.t('group.year'), value: 'year', type: 'select', options: this.$locales.getYears() }
      ]
    }
  },
  mounted() {
    this.get();
  },
  methods: {
    studentCount(students) {
      if (students == undefined) return 0;
      return students.length;
    },
    get(pageNo=1, filters="") {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/groups`,
        params: {
          pageNo: pageNo,
          pageSize: this.pageSize,
          orderBy: "year",
          queryFilter: filters
        }
      }).then(pageData => {
        this.groups = pageData.data ?? [];
        this.count = pageData.count;
      });
    },
    applyFilter(filters) {
      this.get(1, filters)
    },
    save(group, index) {
      this.$bus.$emit("init-save-group-modal", group, index);
    }
  }
}
</script>

<style scoped>
.home-title {
  margin-top: 110px;
}
</style>