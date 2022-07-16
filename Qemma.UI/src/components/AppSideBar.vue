<template>
  <nav class="col-3 col-lg-2 sidebar">
    <div class="sidebar-sticky pt-3">
      <ul class="nav flex-column">
        <li v-for="tab in tabs" class="nav-item sidebar-item" :key="tab.name">
          <router-link v-if="tab.action == 'redirect'" router-link class="nav-link sidebar-link" active-class="active" :to="tab.to" exact>
            <font-awesome-icon :icon="tab.icon" /> {{$locales.t(tab.name)}}
          </router-link>    
          <a v-else-if="tab.children" class="nav-link sidebar-link" href="Javascript:void(0);" @click="toggleCollapsable(tab.name + '.children')">
            <font-awesome-icon :icon="tab.icon" /> {{$locales.t(tab.name)}}
          </a>
          <a v-else class="nav-link sidebar-link" href="Javascript:void(0);" @click="emitEvent(tab.to)">
            <font-awesome-icon :icon="tab.icon" /> {{$locales.t(tab.name)}}
          </a>
          <ul v-if="tab.children" class="collapsable collapse" :id="tab.name + '.children'">
            <li class="nav-item" v-for="child in tab.children" :key="child.name">
              <router-link v-if="child.action == 'redirect'" router-link class="nav-link sub-link" active-class="active" :to="child.to" exact>
                <font-awesome-icon :icon="child.icon" /> {{$locales.t(child.name)}}
              </router-link>
              <a v-else class="nav-link sub-link" href="Javascript:void(0);" @click="emitEvent(child.to)">
                <font-awesome-icon :icon="child.icon" /> {{$locales.t(child.name)}}
              </a>
            </li>
          </ul>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script>
export default {
  name: "AppSideBar",
  props: {
    tabs: {
      type: Array
    }
  },
  data: () => ({
    lastCollapsableEle: ''
  }),
  methods: {
    toggleCollapsable(id) {
      let element = document.getElementById(id);
      if (this.lastCollapsableEle == id) {
        $(element).collapse('toggle');
      } else {
        if (this.lastCollapsableEle != '') {
          let oldElement = document.getElementById(this.lastCollapsableEle);
          $(oldElement).collapse('hide');
        }
        $(element).collapse('show');
      }
      this.lastCollapsableEle = id;
    },
    emitEvent(event) {
      this.$bus.$emit(event);
    },
    addStakeholder(types) {
      this.$bus.$emit("init-save-stakeholder-modal", null, types, 0);
    },
    selectStakeholder(types, route) {
      this.$bus.$emit("init-select-stakeholder-modal", types, (id) => {
        this.$router.push(route.replace('{st-id}', id));
      });
    },
    addProduct() {
      this.$bus.$emit("init-save-product-modal", null, 0);
    },
    addCheque() {
      let route = `/cheques/create?stakeholderId={st-id}`
      this.$bus.$emit("init-select-stakeholder-modal", [1,2,3,4], (stakeholderId) => {
        this.$router.push(route.replace('{st-id}', stakeholderId));
      });
    },
    editAccount() {
      this.$bus.$emit("init-account-settings-modal");
    }
  }
}
</script>

<style>
.collapsable {
  padding-right: 20px;
  list-style-type: none;
  background: var(--nested-nav);
}
</style>