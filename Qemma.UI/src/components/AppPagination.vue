<template>
  <ul v-if="pager.pages && pager.pages.length && pageSize != -1 && pageSize < totalCount" class="pagination pagination-ul w-100" dir="ltr">
    <li class="page-item first pagination-li" :class="{'disabled': pager.currentPage === 1}">
      <a class="page-link pagination-a" @click="setPage(1)">
        <font-awesome-icon :icon="labels.first" />
      </a>
    </li>
    <li class="page-item previous pagination-li" :class="{'disabled': pager.currentPage === 1}">
      <a class="page-link pagination-a" @click="setPage(pager.currentPage - 1)">
        <font-awesome-icon :icon="labels.previous" />
      </a>
    </li>
    <li v-for="page in pager.pages" :key="page" class="page-item page-number pagination-li" :class="{'active': pager.currentPage === page}">
      <a class="page-link pagination-a" @click="pager.currentPage === page ? '' : setPage(page)">{{page}}</a>
    </li>
    <li class="page-item next pagination-li" :class="{'disabled': pager.currentPage === pager.totalPages}">
      <a class="page-link pagination-a" @click="setPage(pager.currentPage + 1)">
        <font-awesome-icon :icon="labels.next" />
      </a>
    </li>
    <li class="page-item last pagination-li" :class="{'disabled': pager.currentPage === pager.totalPages}">
      <a class="page-link pagination-a" @click="setPage(pager.totalPages)">
        <font-awesome-icon :icon="labels.last" />
      </a>
    </li>
  </ul>
</template>

<script>
    
export default {
  name: "PaginationComponent",
  props: {
    initialPage: {
      type: Number,
      default: 1
    },
    pageSize: {
      type: Number,
      default: 10
    },
    totalCount: {
      type: Number,
      default: 10
    }
  },
  data () {
    return {
      labels: {
        first: 'fas fa-angle-double-left',
        last: 'fas fa-angle-double-right',
        previous: 'fas fa-angle-left',
        next: 'fas fa-angle-right'
      },
      pager: {},
      maxSize: 10
    }
  },
  created () {
    if (!this.$listeners.changePage) {
      throw 'Missing required event listener: "changePage"';
    }
    window.addEventListener('resize', this.WindowHandelResize);
    this.WindowHandelResize();

    // set to initial page
    this.setPage(this.initialPage, true);
  },
  methods: {
    setPage(page, init=false) {
      if (this.pageSize != -1) { 
        this.pager = this.$helper.paginate(this.totalCount, page, this.pageSize, this.maxSize);
      }
      if (!init) this.$emit('changePage', page);
    },
    WindowHandelResize(){
      let width = $(window).width();
      if(width >= 1200)
        this.maxSize = parseInt(1140 / 50);
      if(width < 1200 && width >= 992)
        this.maxSize = parseInt(960 / 50);
      if(width < 992 && width >= 768)
        this.maxSize = parseInt(720 / 50);
      if(width < 768 && width >= 576)
        this.maxSize = parseInt(540 / 50);
      if(width < 576)
        this.maxSize = parseInt(400 / 50);

      this.maxSize -= 8;
      this.maxSize = Math.max(this.maxSize, 3);
      if (this.pageSize == -1) return;
      this.pager = this.$helper.paginate(this.totalCount, this.pager.currentPage, this.pageSize, this.maxSize);
    }
  },
  watch: {
    totalCount() {
      if (this.pageSize == -1) return;
      this.pager = this.$helper.paginate(this.totalCount, this.pager.currentPage, this.pageSize, this.maxSize);
    }
  }
}
</script>

<style scoped>
.page-item.active .page-link {
  background-color: var(--btn-primary) !important;
  border-color: var(--btn-primary) !important;
}
.pagination-ul{
  padding: 0;
  display: 'inline-block';
  justify-content: center;
  bottom: 0;
}
.pagination-li{
  display: 'inline';
  text-align: 'center';
  cursor: pointer;
  margin: 1px;
}
.pagination-a{
  padding: '6px 12px';
  display: 'block';
  float: 'left';
  border-radius: 8px !important;
}
</style>