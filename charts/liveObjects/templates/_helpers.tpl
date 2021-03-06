{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "liveobjects.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "liveobjects.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "postgresql.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "liveobjects.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "liveobjects.labels" -}}
helm.sh/chart: {{ include "liveobjects.chart" . }}
{{ include "liveobjects.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "liveobjects.selectorLabels" -}}
app.kubernetes.io/name: {{ include "liveobjects.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "liveobjects.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "liveobjects.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL password
*/}}
{{- define "postgresql.password" -}}
{{- if .Values.postgresql.postgresqlPassword }}
    {{- .Values.postgresql.postgresqlPassword -}}
{{- else -}}
    {{- randAlphaNum (.Values.postgresql.password.length | int) -}}
{{- end -}}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "postgresql.secretName" -}}
{{- if .Values.postgresql.existingSecret }}
    {{- printf "%s" .Values.postgresql.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "postgresql.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "loServer.secretName" -}}
{{- if .Values.loServer.existingSecret }}
    {{- printf "%s" .Values.loServer.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "lo.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return liveobjects admin password
*/}}
{{- define "loServer.adminPassword" -}}
{{- if .Values.loServer.user.adminPassword }}
    {{- .Values.loServer.user.adminPassword -}}
{{- else -}}
    {{- randAlphaNum (.Values.loServer.password.length | int) -}}
{{- end -}}
{{- end -}}

{{/*
Return liveobjects root password
*/}}
{{- define "loServer.rootPassword" -}}
{{- if .Values.loServer.user.rootPassword }}
    {{- .Values.loServer.user.rootPassword -}}
{{- else -}}
    {{- randAlphaNum (.Values.loServer.password.length | int) -}}
{{- end -}}
{{- end -}}

{{/*
Return liveobjects systesm_admin password
*/}}
{{- define "loServer.system_adminPassword" -}}
{{- if .Values.loServer.user.system_adminPassword }}
    {{- .Values.loServer.user.system_adminPassword -}}
{{- else -}}
    {{- randAlphaNum (.Values.loServer.password.length | int) -}}
{{- end -}}
{{- end -}}

{{/*
Return liveobjects license_admin password
*/}}
{{- define "loServer.license_adminPassword" -}}
{{- if .Values.loServer.user.license_adminPassword }}
    {{- .Values.loServer.user.license_adminPassword -}}
{{- else -}}
    {{- randAlphaNum (.Values.loServer.password.length | int) -}}
{{- end -}}
{{- end -}}