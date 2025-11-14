# 🌊 Convert PDF to DB - Tábua de Marés

Este projeto é responsável por processar e converter dados de marés de arquivos PDF para um banco de dados estruturado, alimentando a **API Tábua de Marés** disponível em [tabuamare.devtu.qzz.io](https://tabuamare.devtu.qzz.io/api/v1).

## 📋 Sobre o Projeto

O **Convert PDF to DB** é uma ferramenta desenvolvida em [V Language](https://vlang.io/) que automatiza o processo de extração, normalização e armazenamento de dados de marés do litoral brasileiro. Os dados são extraídos de documentos PDF oficiais e estruturados em um banco de dados PostgreSQL para consumo pela API pública.

📦 Além disso, este repositório disponibiliza um banco de dados SQLite atualizado para o ano corrente, contendo os mesmos dados que estão em produção no PostgreSQL, pronto para uso em projetos e objetivos próprios.

### 📄 Fonte Oficial dos Dados

Todos os dados oferecidos como API podem ser encontrados facilmente no formato PDF na página oficial da Marinha do Brasil: [https://www.marinha.mil.br/cppb/tabuas_de_mare](https://www.marinha.mil.br/cppb/tabuas_de_mare), especificamente aqui: [https://www.marinha.mil.br/chm/dados-do-segnav/dados-de-mare-mapa](https://www.marinha.mil.br/chm/dados-do-segnav/dados-de-mare-mapa)

### 🔗 Projetos Relacionados

- **API Principal**: [Ddiidev/tabua_mare_api](https://github.com/Ddiidev/tabua_mare_api)
- **Site Oficial**: [tabuamare.devtu.qzz.io](https://tabuamare.devtu.qzz.io/)

## 🚀 Funcionalidades

- ✅ **Conversão automática** de PDFs para texto usando `pdftotext`
- ✅ **Normalização inteligente** dos dados extraídos
- ✅ **Estruturação hierárquica** dos dados (Porto → Mês → Dia → Hora)
- ✅ **Inserção automática** no banco PostgreSQL
- ✅ **Processamento em lote** de múltiplos arquivos
- ✅ **Benchmark detalhado** de performance
- ✅ **Log de processamento** em tempo real
- ✅ **Cobertura nacional** (todos os estados costeiros)

## 📊 Estrutura dos Dados

O projeto organiza os dados de marés em uma estrutura hierárquica:

```
DataMare (Porto)
├── GeoLocation (Coordenadas geográficas)
└── MonthData (Dados mensais)
    └── DayData (Dados diários)
        └── HourData (Dados por hora)
```

### 🗃️ Entidades do Banco de Dados

| Tabela         | Descrição               | Campos Principais                         |
| -------------- | ----------------------- | ----------------------------------------- |
| `data_mare`    | Informações do porto    | nome, estado, fuso horário, carta náutica |
| `geo_location` | Coordenadas geográficas | latitude, longitude (graus e decimal)     |
| `month_data`   | Dados mensais           | mês, nome do mês                          |
| `day_data`     | Dados diários           | dia, nome do dia da semana                |
| `hour_data`    | Dados horários          | hora, nível da maré                       |

## 🛠️ Tecnologias Utilizadas

- **[V Language](https://vlang.io/)** - Linguagem de programação principal
- **PostgreSQL** - Banco de dados relacional
- **pdftotext** - Ferramenta para extração de texto de PDFs
- **Benchmark nativo** - Monitoramento de performance

## 📁 Estrutura do Projeto

```
convert_pdf_to_db/
├── entities/           # Definições das entidades do banco
│   ├── data_mare.v
│   ├── geo_location.v
│   ├── day_data.v
│   ├── hour_data.v
│   └── month_data.v
├── models/             # Modelos de dados para processamento
├── types/              # Tipos customizados
├── pdf/                # Arquivos PDF organizados por estado
│   ├── al/            # Alagoas
│   ├── ap/            # Amapá
│   ├── ba/            # Bahia
│   ├── ce/            # Ceará
│   ├── es/            # Espírito Santo
│   ├── ma/            # Maranhão
│   ├── pa/            # Pará
│   ├── pb/            # Paraíba
│   ├── pe/            # Pernambuco
│   ├── pi/            # Piauí
│   ├── pr/            # Paraná
│   ├── rj/            # Rio de Janeiro
│   ├── rn/            # Rio Grande do Norte
│   ├── rs/            # Rio Grande do Sul
│   ├── sc/            # Santa Catarina
│   ├── se/            # Sergipe
│   └── sp/            # São Paulo
├── main.v              # Arquivo principal
├── normalize_pdf_to_text.v  # Lógica de normalização
├── siglas.md          # Glossário de siglas técnicas
└── current_state.log  # Log de processamento
```

## 🔧 Pré-requisitos

### Dependências do Sistema

- **V Language** - [Instruções de instalação](https://github.com/vlang/v#installing-v-from-source)
- **PostgreSQL** - Banco de dados
- **pdftotext** - baixe o executável pre-compilado www.xpdfreader.com

## ⚙️ Configuração

### 1. Configuração do Banco de Dados

O projeto está configurado para conectar ao banco PostgreSQL. Edite a string de conexão em `main.v`:

```v
const conn_str = r'postgresql://usuario:senha@host:porta/database'
```

### 2. Estrutura de Diretórios

Certifique-se de que os arquivos PDF estejam organizados na pasta `pdf/` seguindo a estrutura por estados.

## 🚀 Como Executar

### Execução Simples

```bash
v run .
```

### Execução com Compilação

```bash
v . -o convert_pdf_to_db
./convert_pdf_to_db
```

## 📈 Processo de Execução

O sistema executa as seguintes etapas para cada arquivo PDF:

1. **🔍 Descoberta de Arquivos** - Varre recursivamente a pasta `pdf/`
2. **📄 Conversão PDF→Texto** - Extrai texto usando `pdftotext`
3. **🔧 Normalização** - Processa e estrutura os dados extraídos
4. **🏗️ Criação de Entidades** - Converte para objetos V
5. **💾 Inserção no Banco** - Armazena no PostgreSQL
6. **📊 Benchmark** - Registra métricas de performance

### Exemplo de Saída

```
🚀 Iniciando processamento de PDFs para banco de dados...
📊 Total de arquivos PDF encontrados: 127

📄 Processando arquivo 1/127: 26_-_porto_de_maceio_-_al_-_86-88.pdf
   ✅ Conversão PDF→Texto
   ✅ Normalização e parsing
   ✅ Conversão para entidade
   ✅ Inserção no banco de dados
   ✅ Arquivo processado com sucesso

📊 Relatório final de benchmark:
Processamento completo de PDFs para banco de dados: 2m 34s
```

## 📋 Estados e Portos Cobertos

O projeto processa dados de marés de **todos os estados costeiros do Brasil**:

| Estado              | Sigla | Portos Incluídos                                                                    |
| ------------------- | ----- | ----------------------------------------------------------------------------------- |
| Alagoas             | AL    | Porto de Maceió                                                                     |
| Amapá               | AP    | Barra Norte, Igarapé Grande, Porto de Santana                                       |
| Bahia               | BA    | Madre de Deus, Aratu, Salvador, Ilhéus                                              |
| Ceará               | CE    | Terminal do Pecém, Porto de Mucuripe                                                |
| Espírito Santo      | ES    | Barra do Riacho, Tubarão, Vitória, Trindade, Ponta do Ubu                           |
| Maranhão            | MA    | São Luís, Alumar, Ponta da Madeira, Itaqui, Tutóia                                  |
| Pará                | PA    | Ilha dos Guarás, Salinópolis, Mosqueiro, Belém, Vila do Conde, Breves               |
| Paraíba             | PB    | Porto de Cabedelo                                                                   |
| Pernambuco          | PE    | Fernando de Noronha, Recife, Suape                                                  |
| Piauí               | PI    | Porto de Luís Correia                                                               |
| Paraná              | PR    | Ponta do Felix, Paranaguá, Barra de Paranaguá                                       |
| Rio de Janeiro      | RJ    | Porto do Açu, Imbetiba, Rio de Janeiro, Itaguaí, Forno, Ilha Guaíba, Angra dos Reis |
| Rio Grande do Norte | RN    | Areia Branca, Macau, Guamaré, Natal                                                 |
| Rio Grande do Sul   | RS    | Porto do Rio Grande                                                                 |
| Santa Catarina      | SC    | São Francisco do Sul, Itajaí, Florianópolis, Imbituba                               |
| Sergipe             | SE    | Terminal Inácio Barbosa, Capitania dos Portos                                       |
| São Paulo           | SP    | São Sebastião, Santos                                                               |

## 📝 Logs e Monitoramento

- **current_state.log** - Log detalhado do processamento
- **Benchmark integrado** - Métricas de performance em tempo real
- **Saída no console** - Progresso visual com emojis

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🔗 Links Úteis

- **API de Produção**: [tabuamare.devtu.qzz.io/api/v1](https://tabuamare.devtu.qzz.io/api/v1)
- **Documentação da API**: [tabuamare.devtu.qzz.io/docs](https://tabuamare.devtu.qzz.io/docs)
- **Playground da API**: [tabuamare.devtu.qzz.io/playground](https://tabuamare.devtu.qzz.io/playground)
- **Repositório da API**: [github.com/Ddiidev/tabua_mare_api](https://github.com/Ddiidev/tabua_mare_api)

## 📞 Suporte

Para dúvidas, sugestões ou problemas:

- Abra uma [issue](https://github.com/Ddiidev/convert_pdf_to_db/issues) no GitHub
- Consulte a documentação da API principal

---

**Desenvolvido com ❤️ para o Dev para Dev**
