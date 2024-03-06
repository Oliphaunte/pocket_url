export default {
  mounted() {
    this.handleEvent('download_csv', ({ data }) => {
      console.log(data)
      let link = document.createElement('a')
      link.href = `data:text/csv;charset=utf-8,${encodeURIComponent(data)}`
      link.download = 'stats.csv'
      link.click()
    })
  },
}
