module main

import os
import time
$if using_sqlite ? {
	import db.sqlite as db_provider
} $else {
	import db.pg as db_provider
}
import entities
import benchmark

const pg_conn_str = r'postgresql://'
const sqlite_conn_str = r'taubinha.sqlite'

const year = time.now().year

fn main() {
	// Inicializar benchmark
	mut b := benchmark.new_benchmark()
	mut log := os.open_file('./current_state.log', 'a') or { panic(err) }
	defer {
		log.close()
	}

	println('🚀 Iniciando processamento de PDFs para banco de dados...')
	b.measure('Inicialização do sistema')

	mut pool_conn := new()!
	mut conn := pool_conn.get()!
	mut dbase := conn as db_provider.DB

	b.measure('Conexão com banco de dados')

	sql dbase {
		create table entities.GeoLocation
		create table entities.HourData
		create table entities.DayData
		create table entities.MonthData
		create table entities.DataMare
	}!
	b.measure('Criação de tabelas no banco')

	dbase.close()!
	pool_conn.put(conn)!
	conn = pool_conn.get()!
	dbase = conn as db_provider.DB

	pdf_files := list_all_pdf('.${os.path_separator}pdf/${year}')
	println('📊 Total de arquivos PDF encontrados: ${pdf_files.len}')
	b.measure('Listagem de arquivos PDF')

	for i, current_path in pdf_files {
		println('\n📄 Processando arquivo ${i + 1}/${pdf_files.len}: ${os.file_name(current_path)}')

		log.write_string('\n📄 Processando arquivo ${i + 1}/${pdf_files.len}: ${os.file_name(current_path)}')!

		// ETAPA 1: Conversão PDF para texto
		output := convert_pdf_to_text(current_path)!
		b.measure('   ✅ Conversão PDF→Texto')

		// ETAPA 2: Normalização e parsing dos dados
		text_normalized := normalize_pdf_to_text(output)!
		b.measure('   ✅ Normalização e parsing')

		// ETAPA 3: Conversão para entidade
		data := text_normalized.to_entity()
		b.measure('   ✅ Conversão para entidade')

		// ETAPA 4: Inserção no banco de dados
		sql dbase {
			insert data into entities.DataMare
		}!
		b.measure('   ✅ Inserção no banco de dados')

		println('   ✅ Arquivo processado com sucesso')
		log.write_string('\n   ✅ Arquivo processado com sucesso')!
	}

	dbase.close()!
	pool_conn.put(conn)!
	b.measure('Fechamento da conexão com banco')

	println('\n📊 Relatório final de benchmark:')
	println(b.total_message('Processamento completo de PDFs para banco de dados'))
}

fn convert_pdf_to_text(path_pdf string) !string {
	real_path := os.real_path(path_pdf)
	output_file_name := os.file_name(real_path)
	output_path := real_path.split(os.path_separator)#[..-1].join(os.path_separator)
	output_file := '${output_path}${os.path_separator}${output_file_name}.txt'

	if os.exists(output_file) {
		os.rm(output_file)!
	}
	os.system('pdftotext -raw -enc UTF-8 "${real_path}" "${output_file}"')
	return output_file
}

fn list_all_pdf(path string) []string {
	mut pdfs := []string{}
	real_path := os.real_path(path)
	for mut current_path in os.ls(real_path) or { [] } {
		current_path = '${real_path}${os.path_separator}${current_path}'

		if os.is_dir(current_path) {
			pdfs << list_all_pdf(current_path)
		} else if os.is_file(current_path) {
			if current_path.ends_with('.pdf') {
				pdfs << current_path
			}
		}
	}
	return pdfs
}
