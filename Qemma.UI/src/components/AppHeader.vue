<template>
  <div>
    <nav class="navbar navbar-dark bg-primary shadow d-flex justify-content-end">
      <div class="dropdown">
        <button class="btn dropdown-toggle text-white" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-expanded="false">
          <font-awesome-icon icon="fas fa-language" />
        </button>
        <div class="dropdown-menu dropdown-menu-left" aria-labelledby="dropdownMenuButton">
          <button class="btn" @click="changeLang('ar')">
            <img alt="egypt" src="../assets/egypt.png" class="img-size margin"/>
            <span class="dropdown-item p-0">اللغة العربية</span>  
          </button>
          <button class="btn" @click="changeLang('en')">
            <img alt="egypt" src="../assets/usa.png" class="img-size"/>
            <span class="dropdown-item p-0">English</span>
          </button>
        </div>
      </div>
    </nav>
  </div>
</template>

<script>
import ConfirmMessageModal from './ConfirmMessageModal.vue';

export default {
  name: 'AppHeader',
  components: { ConfirmMessageModal },
  data: () => ({
    dialog: false
  }),
  methods: {
    changeLang(code) {
      if (localStorage.lang == code) return;
      localStorage.lang = code;
      this.$router.go();
    }
  }
}
</script>

<style scoped>
.dropdown-menu {
  right: 0;
  left: auto;
}
[dir=rtl] .dropdown-menu {
  right: auto !important;
  left: 0 !important;
}
.img-size {
  width: 30px;
  height: 30px;
  margin: 0 5px;
}
.dropdown-item {
  display: inline;
}
</style>