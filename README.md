# Helm Development - Named Templates

## What is  named template ?**
- A template defined inside a file (_helpers.tpl) and given a name.

## How to declare a named template ?**
- We can declare it using define action
- What is the naming convention for named templates ?
- Template names are global
- If you declare two templates with the same name, whichever one is loaded last will be the one used.
- Template name: <chartname>.<relevant-template-name>
- Example: helmtemplate.labels

## Step-01: Introduction
- Create Named Template
- Call the named template using template action
- Pass Root Object dot (.) to template action provided if we are using Helm builtin objects in our named template
- For `template call` use `pipelines` and see if it works
- Replace `template call` with special purpose function `include` in combination with `pipelines` and test it


## Step-02: Create a Named Template
- **File Location:** deployment.yaml
- Define the below named template in `deployment.yaml`
```t
{{/* Common Labels */}}
{{- define "helmtemplate.labels"}}
    app: nginx
{{- end }}
```

## Step-03: Call the named template using template action
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-{{ .Chart.Name }}-deployment
  labels:
  {{- template "helmtemplate.labels" }}
```

## Step-04: Test the output with template action
```t
# Change to Chart Directory
cd helmtemplate

# Helm Template Command
helm template namedtemplate .

# Helm Install with dry-run command
helm install namedtemplate . --dry-run

# Helm Release
helm install namedtemplate . --atomic
kubectl get deploy
kubectl describe deploy <DEPLOYMENT-NAME>
helm uninstall namedtemplate
```

## Step-05: Add one Builtin Object Chart.Name to labels
```t
{{/* Common Labels */}}
{{- define "helmtemplate.labels"}}
    app: nginx
    chartname: {{ .Chart.Name }}
{{- end }}
```

## Step-06: Test the output with template action
```t
# Change to Chart Directory
cd helmtemplate

# Helm Template Command
helm template namedtemplate .

# Helm Install with dry-run command
helm install namedtemplate . --dry-run
Observation:
1. Chart name filed should be empty
2. Chart Name was not in the scope for our defined template.
3. When a named template (created with define) is rendered, it will receive the scope passed in by the template call.
4. No scope was passed in, so within the template we cannot access anything in "."
5. This is easy to fix. We simply pass a scope to the template
```

## Step-07: Pass scope to the template call
- Add dot "." (Root Object or period) at the end of template call to pass scope to template call
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-{{ .Chart.Name }}-deployment # Action Element
  labels:
  {{- template "helmtemplate.labels" . }}
```

## Step-08: Test the output with template action when scope passed to template call
```t
# Change to Chart Directory
cd helmtemplate

# Helm Template Command
helm template namedtemplate .

# Helm Install with dry-run command
helm install namedtemplate . --dry-run
Observation:
Chart Name should be displayed
```

## Step-09: Pipe an Upper function to template
```t
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-{{ .Chart.Name }}-deployment # Action Element
  labels:
  {{- template "helmtemplate.labels" . | upper }}
```

## Step-10: Test the output when template action + pipe + upper function
```t
# Change to Chart Directory
cd helmtemplate

# Helm Template Command
helm template namedtemplate .

# Helm Install with dry-run command
helm install namedtemplate . --dry-run
Observation:
1. Should fail with error. What is the reason for failure ?
2. Template is an action, and not a function, there is no way to pass the output of a template call to other functions;
```

## Step-11: Replace Template action with Special Purpose include function
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-{{ .Chart.Name }}-deployment # Action Element
  labels:
  {{- include "helmtemplate.labels" . | upper }}
```

## Step-10: Test the output include function
```t
# Change to Chart Directory
cd helmtemplate

# Helm Template Command
helm template namedtemplate .

# Helm Install with dry-run command
helm install namedtemplate . --dry-run
Observation:
1. Call include "helmtemplate.labels" -- should be successful
2. Should show all labels in upper case
```
## Step-11: Underscoe file (_helpers.tpl)
- Move the named template `helmtemplate.labels` to `_helpers.tpl` file
- But files whose name begins with an underscore (_) are assumed to not have a kubernetes manifest inside.
- These files are not rendered to Kubernetes object definitions, but are available everywhere within other chart templates for use.
- These files are used to store partials and helpers.
```t
{{/* Common Labels */}}
{{- define "helmtemplate.labels"}}
    app: nginx
    chartname: {{ .Chart.Name }}
{{- end }}
```

## Step-12: Test the output after moving named template to _helpers.tpl
```t
# Change to Chart Directory
cd helmtemplate

# Helm Template Command
helm template namedtemplate .

# Helm Install with dry-run command
helm install namedtemplate . --dry-run
Observation:
1. call include "helmtemplate.labels" -- should be successful
2. Should show all labels in upper case
```
