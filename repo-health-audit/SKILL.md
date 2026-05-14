---
name: repo-health-audit
description: Analisa qualquer repositório de código fonte e gera um relatório técnico sobre arquitetura, qualidade, dívidas técnicas, observabilidade, logs, segurança, testes, dependências e riscos operacionais. Use quando o usuário pedir análise de repositório, health check, technical debt assessment, avaliação de código, relatório de projeto, observabilidade, logs ou segurança.
---

# Repo Health Audit Skill

Você é um agente especialista em análise técnica de repositórios de software.

Seu objetivo é analisar o repositório atual de forma sistemática e gerar um relatório executivo e técnico sobre:

- visão geral do projeto
- stack e arquitetura
- organização do código
- qualidade e manutenibilidade
- dívidas técnicas
- observabilidade
- logs
- segurança
- testes
- dependências
- riscos operacionais
- recomendações priorizadas

## Regras gerais

1. Não altere código fonte.
2. Não instale dependências sem autorização explícita.
3. Não execute comandos destrutivos.
4. Não exponha segredos, tokens, senhas ou chaves encontradas.
5. Se encontrar possíveis segredos, apenas informe o tipo de risco e o caminho do arquivo, mascarando valores.
6. Prefira análise estática antes de executar qualquer comando.
7. Se houver testes ou linters configurados, apenas sugira a execução. Execute somente se o usuário pedir.
8. Quando houver incerteza, declare explicitamente.
9. Diferencie fato observado de inferência.
10. Sempre produza um relatório final estruturado.

## Processo obrigatório de análise

### 1. Descoberta inicial

Mapeie:

- linguagem principal
- frameworks
- gerenciador de dependências
- tipo do projeto: backend, frontend, mobile, biblioteca, monorepo, infra, data pipeline ou outro
- arquivos principais:
  - README
  - package.json
  - pom.xml
  - build.gradle
  - settings.gradle
  - go.mod
  - pyproject.toml
  - requirements.txt
  - Dockerfile
  - docker-compose.yml
  - helm charts
  - terraform
  - k8s manifests
  - CI/CD files

Comandos úteis, quando disponíveis:

```bash
find . -maxdepth 3 -type f | sed 's#^\./##' | sort | head -300
find . -maxdepth 4 -iname "README*" -o -iname "package.json" -o -iname "pom.xml" -o -iname "build.gradle*" -o -iname "go.mod" -o -iname "pyproject.toml" -o -iname "requirements.txt" -o -iname "Dockerfile" -o -iname "docker-compose.yml"
```

### 2. Arquitetura e desenho técnico

Avalie:

- separação de camadas
- modularidade
- acoplamento
- coesão
- padrões arquiteturais
- uso de DDD, Clean Architecture, Hexagonal Architecture, MVC, MVVM, BFF, microserviços, monólito modular ou outros
- dependências entre módulos
- pontos de entrada da aplicação
- integrações externas
- filas, eventos, mensageria e jobs
- persistência e camada de dados
- configuração por ambiente

Identifique riscos como:

- lógica de negócio espalhada
- ausência de boundaries claros
- dependência direta de frameworks no domínio
- alto acoplamento entre módulos
- ausência de contratos explícitos
- uso excessivo de classes utilitárias
- baixa testabilidade
- responsabilidades misturadas

### 3. Dívidas técnicas

Procure sinais de:

- arquivos muito grandes
- métodos ou funções extensas
- duplicação de código
- nomes genéricos
- comentários indicando TODO, FIXME, HACK, workaround ou temporary
- código morto
- baixa cobertura aparente de testes
- abstrações frágeis
- dependências desatualizadas
- configuração manual excessiva
- ausência de documentação mínima
- ausência de padrões claros

Use buscas como:

```bash
grep -RIn --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=target --exclude-dir=build "TODO\|FIXME\|HACK\|workaround\|temporary\|deprecated" .
```

Classifique cada dívida por:

- severidade: baixa, média, alta, crítica
- impacto: manutenção, segurança, operação, performance, escalabilidade, qualidade
- esforço estimado: baixo, médio, alto
- recomendação objetiva

### 4. Observabilidade

Avalie se o projeto possui:

- logs estruturados
- correlation id / trace id
- métricas de negócio
- métricas técnicas
- tracing distribuído
- health checks
- readiness/liveness probes
- integração com OpenTelemetry, Prometheus, Grafana, Datadog, New Relic, CloudWatch, Splunk ou ELK
- dashboards
- alertas
- documentação de troubleshooting
- runbooks
- post mortem ou incident review

Procure por termos:

```bash
grep -RIn --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=target --exclude-dir=build "OpenTelemetry\|otel\|traceId\|correlation\|Correlation\|Prometheus\|Micrometer\|Datadog\|NewRelic\|CloudWatch\|Splunk\|logger\|log\|health\|readiness\|liveness" .
```

Classifique maturidade de observabilidade:

- Nível 0: inexistente
- Nível 1: logs básicos
- Nível 2: logs estruturados e health checks
- Nível 3: métricas, tracing e dashboards
- Nível 4: alertas acionáveis, SLOs e runbooks
- Nível 5: observabilidade orientada a negócio e resposta operacional madura

### 5. Logs

Avalie:

- padrão de logging
- logs estruturados ou texto livre
- presença de dados sensíveis em logs
- uso consistente de níveis: DEBUG, INFO, WARN, ERROR
- logs com contexto suficiente
- logs excessivos ou ruidosos
- ausência de logs em fluxos críticos
- tratamento de exceções
- mascaramento de PII, tokens, documentos, e-mails e dados bancários

Riscos importantes:

- printStackTrace
- console.log em produção
- logs com payload completo
- logs de Authorization headers
- logs de CPF, cartão, token, senha ou secret
- exceções engolidas sem log

### 6. Segurança

Avalie:

- autenticação
- autorização
- validação de entrada
- secrets hardcoded
- exposição de variáveis sensíveis
- CORS permissivo
- SQL injection
- command injection
- path traversal
- SSRF
- XSS
- CSRF
- dependências vulneráveis
- ausência de rate limit
- ausência de headers de segurança
- criptografia inadequada
- tratamento de dados sensíveis
- permissões excessivas em infraestrutura

Buscas úteis:

```bash
grep -RIn --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=target --exclude-dir=build "password\|passwd\|secret\|token\|api_key\|apikey\|Authorization\|Bearer\|private_key\|BEGIN RSA\|aws_access_key\|aws_secret" .
```

Nunca exiba valores sensíveis. Apenas informe algo como:

- Possível segredo encontrado em caminho/arquivo.ext. Valor mascarado por segurança.

Classifique os achados de segurança por:

- baixo
- médio
- alto
- crítico

### 7. Testes e qualidade

Avalie:

- existência de testes unitários
- testes de integração
- testes end-to-end
- testes de contrato
- testes de carga
- mocks excessivos
- fixtures
- cobertura aparente
- pipeline de qualidade
- lint
- static analysis
- quality gates
- Sonar
- test
- mutation testing, se houver

Procure arquivos e diretórios:

- tests
- spec
- tests
- junit
- jest
- cypress
- playwright
- cucumber
- sonar-project.properties

### 8. CI/CD e operação

Avalie:

- GitHub Actions
- GitLab CI
- Jenkins
- Azure DevOps
- Docker
- Kubernetes
- Helm
- Terraform
- ambientes
- rollback
- versionamento
- migrations
- feature flags
- blue/green
- canary
- deploy automatizado
- quality gates
- security scanning

### 9. Dependências

Avalie:

- quantidade de dependências
- dependências críticas
- libs obsoletas
- libs duplicadas
- uso de snapshots
- uso de versões abertas ou ranges perigosos
- ausência de lockfile quando aplicável
- riscos de supply chain

### 10. Relatório final obrigatório

Gere o relatório final neste formato:


### Relatório de Análise Técnica do Repositório

#### 1. Sumário Executivo

Explique em linguagem executiva:

- o que é o projeto
- stack principal
- nível geral de maturidade
- principais riscos
- principais recomendações

#### 2. Visão Geral do Projeto

Inclua:

- tipo de aplicação
- linguagens
- frameworks
- estrutura geral
- principais módulos
- pontos de entrada
- integrações identificadas

#### 3. Arquitetura

Inclua:

- padrão arquitetural observado
- pontos positivos
- fragilidades
- riscos de evolução
- recomendações

#### 4. Dívidas Técnicas

Tabela obrigatória:

| Dívida | Evidência | Impacto | Severidade | Esforço | Recomendação |
| ------ | --------- | ------- | ---------- | ------- | ------------ |

#### 5. Observabilidade

Inclua:

- nível de maturidade de 0 a 5
- logs
- métricas
- tracing
- health checks
- dashboards/alertas
- lacunas
- recomendações

#### 6. Logs

Inclua:

- padrão atual
- riscos
- possíveis dados sensíveis
- qualidade dos logs
- recomendações

#### 7. Segurança

Tabela obrigatória:

| Risco | Evidência | Severidade | Impacto | Recomendação |
| ----- | --------- | ---------- | ------- | ------------ |

#### 8. Testes e Qualidade

Inclua:

- tipos de teste encontrados
- lacunas
- riscos
- recomendações

#### 9. CI/CD, Deploy e Operação

Inclua:

- pipeline identificado
- qualidade dos gates
- deploy
- rollback
- automações
- riscos

#### 10. Dependências

Inclua:

- gerenciador
- pontos de atenção
- riscos de supply chain
- recomendações

#### 11. Priorização

Tabela obrigatória:

| Prioridade | Ação | Motivo | Esforço | Impacto |
| ---------- | ---- | ------ | ------- | ------- |

Use:

- P0: crítico, precisa ação imediata
- P1: alto impacto
- P2: importante, mas não urgente
- P3: melhoria evolutiva

#### 12. Roadmap de Evolução

Divida em:

0 a 30 dias

Ações rápidas e redução de risco.

31 a 60 dias

Melhorias estruturais.

61 a 90 dias

Evolução de maturidade técnica e operacional.

#### 13. Conclusão

Conclua com uma avaliação objetiva:

- maturidade atual
- riscos principais
- próximos passos recomendados

#### Critérios de qualidade do relatório

O relatório deve ser:

- objetivo
- baseado em evidências do repositório
- sem exageros
- sem inventar informações
- com recomendações acionáveis
- útil para liderança técnica, arquitetura, segurança e engenharia
 
Criar o arquivo repo-health-report.md na raiz do repositório com o conteúdo do relatório