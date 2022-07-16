<template>
  <div>
    <div class="d-flex justify-content-center">
      <img class="my-4" src="@/assets/logo.png" alt="accounting logo" width="256" height="256">
    </div>
    <base-form :model="model" ref="form" class="form-signin">
      <div class="form-group">
        <label class="control-label">{{$locales.t('signin.username')}}</label>
        <input onfocus="this.select();" class="form-control mb-0" required v-model="model.username" 
          :placeholder="$locales.t('signin.username.ph')" />
        <span data-validation-prop="username" 
          data-validation-rule="v => v != '' || 'signin.username.invalid'" />
      </div>
      <div class="form-group">
        <label class="control-label">{{$locales.t('signin.password')}}</label>
        <div class="input-group">
          <input onfocus="this.select();" class="form-control mb-0" :type="showPassword ? 'text' : 'password'" 
            required v-model="model.password" :placeholder="$locales.t('signin.password.ph')" />
          <span data-validation-prop="password"
            data-validation-rule="v => v != '' || 'signin.password.invalid'" />
          <div class="input-group-append">
            <span class="input-group-text" id="basic-addon2" @click="() => showPassword=!showPassword">
              <font-awesome-icon v-if="showPassword" icon="fas fa-eye-slash" />
              <font-awesome-icon v-else icon="fas fa-eye" />
            </span>
          </div>
        </div>
      </div>
      <span data-after-submit-prop="password"
        :data-after-submit-message="$locales.t('signin.invalid')" />
      <button class="btn btn-lg btn-primary btn-block" type="submit" @click="signin">{{$locales.t('signin.btn')}}</button>
    </base-form>
  </div>
</template>

<script>
import BaseForm from '@/components/BaseForm.vue'

export default {
  name: 'SignIn',
  components: { BaseForm },
  data: () => ({
    model: { username: '', password: '' },
    showPassword: false
  }),
  methods: {
    signin(e) {
      e.preventDefault()
      e.stopPropagation()
      if (!this.$refs.form.validate()) return;
      this.$http.send({
        url: `${this.$BACKEND_APP_URL}/system/login`,
        method: 'POST',
        data: this.model
      }).then(data => {
        sessionStorage.setItem(this.$helper.userKey, JSON.stringify(data));
        this.$router.replace('/home');
        this.$bus.$emit('user-log-in');
      }).catch(err => {
        if (err.response.status == 400) {
          this.$bus.$emit('form-submit-failed');
        }
      });
    }
  }
}
</script>

<style scoped>
.bd-placeholder-img {
  font-size: 1.125rem;
  text-anchor: middle;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

@media (min-width: 768px) {
  .bd-placeholder-img-lg {
    font-size: 3.5rem;
  }
}
html,
body {
  height: 100%;
}

body {
  display: -ms-flexbox;
  display: flex;
  -ms-flex-align: center;
  align-items: center;
  padding-top: 40px;
  padding-bottom: 40px;
}

.form-signin {
  width: 100%;
  max-width: 330px;
  margin: auto;
}
.form-signin .checkbox {
  font-weight: 400;
}
.form-signin .form-control {
  position: relative;
  box-sizing: border-box;
  height: auto;
  font-size: 16px;
}
.form-signin .form-control:focus {
  z-index: 2;
}
.form-signin input[type="email"] {
  margin-bottom: -1px;
  border-bottom-right-radius: 0;
  border-bottom-left-radius: 0;
}
.form-signin input[type="password"] {
  margin-bottom: 10px;
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}

</style>