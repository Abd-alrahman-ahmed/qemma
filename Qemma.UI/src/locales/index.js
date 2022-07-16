import Vue from 'vue'

var locales = {
  current: {rtl: true},
  _locales: [],

  init: function(locales) {
    this._locales = locales;
    Vue.prototype.$bus.$emit("locales-loaded");
  },

  /* t alias for translate */
  t: function(key) {
    return this.translate(key);
  },
  
  translate: function(key) {
    let text = key;
    if (this.current && this.current.translations && key in this.current.translations)
      text = this.current.translations[key];
    return text; 
  },

  direction: function() {
    return this.current.rtl ? 'rtl' : 'ltr';
  },

  setLocale: function(lang) {
    this.current = this._locales.find(l => l.code == lang) ?? {rtl: true};
  },

  getCurrentLocaleCode() {
    return this.current?.code ?? 'ar';
  },

  getGenders() {
    return [
      { id: 1, name: this.translate("lookups.gender.1") },
      { id: 2, name: this.translate("lookups.gender.2") },
    ]
  },

  getYears() {
    return [
      { id: 1, name: this.translate("lookups.year.1") },
      { id: 2, name: this.translate("lookups.year.2") },
      { id: 3, name: this.translate("lookups.year.3") },
      { id: 4, name: this.translate("lookups.year.4") },
      { id: 5, name: this.translate("lookups.year.5") },
      { id: 6, name: this.translate("lookups.year.6") },
      { id: 7, name: this.translate("lookups.year.7") },
      { id: 8, name: this.translate("lookups.year.8") },
      { id: 9, name: this.translate("lookups.year.9") },
      { id: 10, name: this.translate("lookups.year.10") },
      { id: 11, name: this.translate("lookups.year.11") },
      { id: 12, name: this.translate("lookups.year.12") }
    ]
  },

  getStatus() {
    return [
      { id: 1, name: this.translate("lookups.status.1") },
      { id: 2, name: this.translate("lookups.status.2") },
      { id: 3, name: this.translate("lookups.status.3") },
    ]
  },

  getStudentFilterProps() {
    return [
      { name: this.translate('student.name'), value: 'name', type: 'text', operations: ['contains'] },
      { name: this.translate('student.registrationdate'), value: 'registrationDate', type: 'datetime-local', operations: ['ge', 'le'] },
      { name: this.translate('student.gender'), value: 'gender', type: 'select', options: this.getGenders(), operations: ['eq', 'neq'] },
      { name: this.translate('student.year'), value: 'year', type: 'select', options: this.getYears(), operations: ['eq', 'neq'] },
      { name: this.translate('student.degree'), value: 'degree', type: 'number', operations: ['eq', 'neq', 'le', 'ge'] },
      { name: this.translate('student.status'), value: 'status', type: 'select', options: this.getStatus(), operations: ['eq', 'neq'] }
    ]
  },

  getLessonsFilterProps() {
    return [
      { name: this.translate('lesson.name'), value: 'name', type: 'text', operations: ['contains'] },
      { name: this.translate('lesson.start'), value: 'start', type: 'datetime-local', operations: ['ge', 'le'] },
    ]
  },

  chartGroupingOptions() {
    return [
      { name: this.translate('filter.monthly'), id: 1 },
      { name: this.translate('filter.daily'), id: 2 }
    ]
  },

  getAttendStaus() {
    return [
      { name: this.translate('lookups.attend.1'), state: true},
      { name: this.translate('lookups.attend.2'), state: false}
    ]
  }
}

export default locales;