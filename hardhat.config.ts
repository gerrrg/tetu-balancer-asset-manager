import { config as dotEnvConfig } from "dotenv"
import "@nomiclabs/hardhat-waffle"
import "@nomiclabs/hardhat-ethers"
import "@nomiclabs/hardhat-etherscan"
import "@nomiclabs/hardhat-web3"
import "@nomiclabs/hardhat-solhint"
import "@typechain/hardhat"
import "hardhat-contract-sizer"
import "hardhat-gas-reporter"
import "hardhat-tracer"
import "solidity-coverage"
import "hardhat-abi-exporter"

dotEnvConfig()
// tslint:disable-next-line:no-var-requires
const argv = require("yargs/yargs")()
  .env("TETU")
  .options({
    hardhatChainId: {
      type: "number",
      default: 137
    },
    maticRpcUrl: {
      type: "string"
    },
    networkScanKey: {
      type: "string"
    },
    privateKey: {
      type: "string",
      default: "85bb5fa78d5c4ed1fde856e9d0d1fe19973d7a79ce9ed6c0358ee06a4550504e" // random account
    },
    maticForkBlock: {
      type: "number",
      default: 29199805
    }
  }).argv

export default {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
      chainId: argv.hardhatChainId,
      timeout: 99999999,
      gas: argv.hardhatChainId === 1 ? 19_000_000 :
        argv.hardhatChainId === 137 ? 19_000_000 :
          argv.hardhatChainId === 250 ? 11_000_000 :
            9_000_000,
      accounts: {
        mnemonic: "test test test test test test test test test test test junk",
        path: "m/44'/60'/0'/0",
        accountsBalance: "100000000000000000000000000000"
      },
    },
    matic: {
      url: argv.maticRpcUrl || '',
      timeout: 99999,
      chainId: 137,
      gas: 12_000_000,
      // gasPrice: 50_000_000_000,
      // gasMultiplier: 1.3,
      accounts: [argv.privateKey],
    },
  },
  etherscan: {
    //  https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html#multiple-api-keys-and-alternative-block-explorers
    apiKey: {
      polygon: argv.networkScanKey
    }
  },
  solidity: {
    compilers: [
      {
        version: "0.8.4",
        settings: {
          optimizer: {
            enabled: true,
            runs: 150
          }
        }
      },
      {
        version: "0.7.1",
        settings: {
          optimizer: {
            enabled: true,
            runs: 150
          }
        }
      }
    ]
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 9999999999
  },
  docgen: {
    path: "./docs",
    clear: true,
    runOnCompile: false,
    except: ["contracts/third_party", "contracts/test"]
  },
  contractSizer: {
    alphaSort: false,
    runOnCompile: false,
    disambiguatePaths: false
  },
  gasReporter: {
    enabled: false,
    currency: "USD",
    gasPrice: 21
  },
  typechain: {
    outDir: "typechain"
  },
  abiExporter: {
    path: "./artifacts/abi",
    runOnCompile: false,
    spacing: 2,
    pretty: true
  }
}
