<template>
  <div class="home">
    <h5 class="home-title">{{$locales.t('views.home.title')}}</h5>
    <table class="table mt-4">
      <thead>
        <tr>
          <th>رقم الشيك</th>
          <th>تاريخ الإصدار</th>
          <th>تاريخ الصرف</th>
          <th>اسم البنك</th>
          <th>اسم الحساب</th>
          <th>القيمة</th>
          <th>المدفوع</th>
          <th>ملاحظات</th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="cheques.length == 0">
          <td colspan="8"><empty-state /></td>
        </tr>
        <tr v-for="cheque in cheques" :key="'cheque-' + cheque.id">
          <td>{{cheque.id}}</td>
          <td>{{$moment(cheque.releaseDate).locale($locales.current).format('MMMM Do dddd YYYY, h:mm:ss a')}}</td>
          <td>{{$moment(cheque.exchangeDate).locale($locales.current).format('MMMM Do dddd YYYY, h:mm:ss a')}}</td>
          <td>{{cheque.bankName}}</td>
          <td>{{cheque.accountName}}</td>
          <td>{{cheque.amount}}</td>
          <td>{{cheque.paid}}</td>
          <td>{{cheque.details}}</td>
        </tr>
      </tbody>
    </table>

    <app-pagination :totalCount="count" @changePage="changePage" />

  </div>
</template>

<script>
export default {
  name: 'Home',
  data: () => ({
    cheques: [],
    count: 0,
    pageSize: -1
  }),
  methods: {
    get(pageNo=1) {
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/home`,
        params: {
          pageNo: pageNo,
          pageSize: this.pageSize
        }
      }).then(pageData => {
        this.cheques = pageData.data;
        this.count = pageData.count;
      });
    },
    changePage(page) {
      this.get(page);
    }
  }
}
</script>

<style scoped>
.home-title {
  margin-top: 110px;
}
</style>