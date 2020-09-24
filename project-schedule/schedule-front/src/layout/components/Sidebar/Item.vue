<script>
export default {
  name: 'MenuItem',
  functional: true,
  props: {
    icon: {
      type: String,
      default: ''
    },
    title: {
      type: String,
      default: ''
    }
  },
  render(h, context) {
    const { icon, title } = context.props
    const vnodes = []

    if (icon) {
      vnodes.push(<svg-icon style='width:19px;height:20px' icon-class={icon}/>)
    }

    if (title) {
      vnodes.push(<span style='position:relative;top:-4px' slot='title'>{(title)}</span>)
    }
    return vnodes
  }
}
</script>
