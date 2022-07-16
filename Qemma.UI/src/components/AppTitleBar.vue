<template>
  <div>
    <header class="app-titlebar">
      <div class="d-flex h-100">
        <div class="drag-region window-title mr-auto px-4 pt-2">
          <span>{{$locales.t('app.title')}}</span>
        </div>
        <div class="window-controls d-flex align-content-center" draggable="false">
          <div v-if="isLogged" class="controls-button cursor-pointer pt-2" @click="logout">
            <font-awesome-icon class="minimize mx-2" icon="fas fa-right-from-bracket" draggable="false" />
          </div>
          <div class="controls-button cursor-pointer pt-2" @click="minimize">
            <font-awesome-icon class="minimize mx-2" icon="fas fa-minus" draggable="false" />
          </div>
          <div class="controls-button cursor-pointer pt-2" @click="maximize">
            <font-awesome-icon class="maximize mx-2" icon="far fa-window-maximize" draggable="false" />
          </div>
          <div class="controls-button close-btn cursor-pointer pt-2" @click="close">
            <font-awesome-icon class="mx-2" icon="fas fa-times" draggable="false" />
          </div>
        </div>
      </div>
    </header>
    <confirm-message-modal v-model="dialog" :title="$locales.t('modals.confirm.closeapp.title')" 
      :message="$locales.t('modals.confirm.closeapp.msg')" @confirm="closeApp" />
    <confirm-message-modal v-model="logoutDialog" title="modals.signout.confirm.title" message="modals.signout.confirm.msg" @confirm="clearData" />
  </div>
</template>

<script>
import ConfirmMessageModal from '@/components/ConfirmMessageModal.vue'

export default {
  name: 'AppTitleBar',
  components: { ConfirmMessageModal },
  data: () => ({
    isLogged: false,
    dialog: false,
    logoutDialog: false
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
  },
  methods: {
    minimize() {
      const { ipcRenderer } = require("electron");
      ipcRenderer.send('minimize');
    },
    maximize() {
      const { ipcRenderer } = require("electron");
      ipcRenderer.send('maximize');
    },
    close() {
      this.dialog = true;
    },
    closeApp() {
      const { ipcRenderer } = require("electron");
      ipcRenderer.send('close');
    },
    logout() {
      this.logoutDialog = true;
    },
    clearData() {
      sessionStorage.removeItem(this.$helper.userKey);
      setTimeout(() => {
        this.$router.replace('/signin');
        this.$bus.$emit('user-log-out');
      }, 250)
    }
  }
}
</script>

<style>
.app-titlebar {
  display: block;
  position: fixed;
  height: 34px;
  width: calc(100% - 2px); /*Compensate for body 1px border*/
  background: var(--titlebar);
  color: var(--titlebar-text);
}
.app-titlebar .drag-region {
  width: 100%;
  height: 100%;
  -webkit-app-region: drag;
}
.window-controls .controls-button:hover {
  background: var(--window-control-hover)
}
.window-controls .controls-button:active {
  background: var(--window-control-active)
}

.close-btn:hover {
  background: var(--window-close-hover) !important;
}
.close-btn:active {
  background: var(--window-close-active) !important;
}
</style>