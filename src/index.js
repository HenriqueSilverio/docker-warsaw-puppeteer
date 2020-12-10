const axios = require('axios')
const delay = require('delay')
const pRetry = require('p-retry')
const puppeteer = require('puppeteer')

const {
  username,
  defaultTimeout
} = require('./config')

;(async () => {
  try {
    const run = async () => {
      const chromeData = await axios.get('http://127.0.0.1:9222/json/version')
      return chromeData.data
    }
    console.log('Trying to get Chromium webSocketDebuggerUrl...')
    const { webSocketDebuggerUrl } = await pRetry(run, {
      onFailedAttempt: async (error) => {
        console.log(`Attempt ${error.attemptNumber} failed. There are ${error.retriesLeft} retries left.`)
        console.log('Delaying 30s before retry...')
        await delay(30000)
      },
      retries: 6
    })
    console.log(`Chromium webSocketDebuggerUrl: ${webSocketDebuggerUrl}...`)
    console.log('Starting Puppeteer...')
    const browser = await puppeteer.connect({
      browserWSEndpoint: webSocketDebuggerUrl,
      defaultViewport: null,
      slowMo: 120
    })
    console.log('Puppeteer started...')
    console.log('Going to caixa.gov.br website...')
    const page = await browser.newPage()
    await page.goto('https://internetbanking.caixa.gov.br/sinbc/#!nb/login', {
      timeout: defaultTimeout,
      waitUntil: ['load', 'domcontentloaded', 'networkidle0']
    })
    await Promise.all([
      page.waitForSelector('.modalBgLoading', { hidden: true, timeout: defaultTimeout }),
      page.waitForSelector('#nomeUsuario', { visible: true, timeout: defaultTimeout }),
      page.waitForSelector('#btnLogin', { visible: true, timeout: defaultTimeout })
    ])
    console.log('Caixa.gov.br loaded...')
    await page.type('#nomeUsuario', username, { delay: 250 })
    await Promise.all([
      page.waitForNavigation({
        timeout: defaultTimeout,
        waitUntil: ['load', 'domcontentloaded', 'networkidle0']
      }),
      page.$eval('#btnLogin', el => el.click())
    ])
  } catch (error) {
    console.log('Maximum retries reached', error)
  }
})()
