const env = require('require-env')

module.exports = {
  username: env.require('CAIXA_USERNAME'),
  defaultTimeout: 2 * 60 * 1000
}
