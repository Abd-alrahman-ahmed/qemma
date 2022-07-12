import ar from '@/assets/locales/ar.json'
import en from '@/assets/locales/en.json'

var locales = {
  current: 'ar',
  ar: ar,
  en: en,
  dir: {
    'ar': 'rtl',
    'en': 'ltr'
  },

  /* t alias for translate */
  t: function(key) {
    return this.translate(key);
  },
  
  translate: function(key) {
    let text = key;
    if (key in this[this.current])
      text = this[this.current][key];
    return text;
  },

  direction: function() {
    return this.dir[this.current];
  },

  setLocale: function(lang) {
    this.current = lang;
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
      { name: this.translate('tbls.students.cols.registrationdate'), value: 'registrationDate', type: 'datetime-local' },
      { name: this.translate('tbls.students.cols.gender'), value: 'gender', type: 'select', options: this.getGenders() },
      { name: this.translate('tbls.students.cols.year'), value: 'year', type: 'select', options: this.getYears() },
      { name: this.translate('tbls.students.cols.degree'), value: 'degree', type: 'number' },
      { name: this.translate('tbls.students.cols.status'), value: 'status', type: 'select', options: this.getStatus() }
    ]
  },

  chartGroupingOptions() {
    return [
      { name: this.translate('app.charts.monthly'), id: 1 },
      { name: this.translate('app.charts.daily'), id: 2 }
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