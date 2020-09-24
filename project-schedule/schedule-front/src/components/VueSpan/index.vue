<template>
  <div>
    <span>{{ value }}</span>
  </div>
</template>

<script>
export default {
  name: 'VueSpan',
  props: {
    value: {
      type: String,
      default: '',
      require: true
    }
  }
}
</script>
