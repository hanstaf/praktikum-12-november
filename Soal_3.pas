uses crt, sysutils;

type
  // Record untuk menyimpan data satu mata kuliah
  MATKUL = record
    NamaMATKUL: string;
    jumlahSKS: integer;
    nilai: string;
  end;

  // Dynamic array untuk menyimpan mata kuliah
  DaftarMataKuliah = array of MATKUL;

  // Record untuk menyimpan data seorang mahasiswa
  mhs = record
    nama: string;
    nim: string;
    jumlahMATKUL: integer;
    mataKuliah: DaftarMataKuliah;
  end;

  // Dynamic array untuk menyimpan mahasiswa
  DaftarMahasiswa = array of mhs;


  // Merapikan isi kolom; teks yang terlalu panjang dipotong saat ditampilkan.
  function IsiKolom(teks: string; lebar: integer): string;
  begin
    if Length(teks) > lebar then
      teks := Copy(teks, 1, lebar);

    IsiKolom := teks + StringOfChar(' ', lebar - Length(teks));
  end;


// Membuat garis tabel sesuai lebar kolom angka.
function GarisTabel(lebarNo, lebarSKS, lebarSkor: integer): string;
begin
  GarisTabel := '+' + StringOfChar('-', lebarNo + 2) +
                '+' + StringOfChar('-', 32) +
                '+' + StringOfChar('-', lebarSKS + 2) +
                '+' + StringOfChar('-', 7) +
                '+' + StringOfChar('-', lebarSkor + 2) + '+';
end;


// Function untuk mengubah nilai huruf menjadi bobot angka
function BobotNilai(nilai: string): real;
begin
  if nilai = 'A' then
    BobotNilai := 4.0
  else if nilai = 'B+' then
    BobotNilai := 3.5
  else if nilai = 'B' then
    BobotNilai := 3.0
  else if nilai = 'C+' then
    BobotNilai := 2.5
  else if nilai = 'C' then
    BobotNilai := 2.0
  else if nilai = 'D' then
    BobotNilai := 1.0
  else if nilai = 'E' then
    BobotNilai := 0.0
  else
    BobotNilai := -1;
end;


// Procedure untuk menginput seluruh data mahasiswa
procedure InputDataMahasiswa(var daftarMhs: DaftarMahasiswa; var jumlahmhs: integer);

var
  i, j: integer;

begin
  writeln('======================================');
  writeln('    INPUT DATA HASIL STUDI MAHASISWA');
  writeln('======================================');

  // Meminta jumlah mahasiswa yang akan diinput, pake repet until biar inputnya selalu lebih dari 0
  repeat
    write('Masukkan jumlah mahasiswa: ');
    readln(jumlahmhs);
  until jumlahmhs >= 1;

  // Menyesuaikan ukuran array dengan jumlah mahasiswa yang diinput
  SetLength(daftarMhs, jumlahmhs);

  // Menginput data setiap mahasiswa
  for i := 0 to jumlahmhs - 1 do
  begin
    writeln;
    writeln('Data Mahasiswa ke-', i + 1);
    writeln('--------------------------------------');

    with daftarMhs[i] do
    begin
      write('Nama mahasiswa       : ');
      readln(nama);

      write('NIM mahasiswa        : ');
      readln(nim);

      // Meminta jumlah mata kuliah yang diambil
      repeat
        write('Jumlah mata kuliah   : ');
        readln(jumlahMATKUL);
      until jumlahMATKUL >= 1;

      // Menyesuaikan ukuran array dengan jumlah mata kuliah yang diinput
      SetLength(mataKuliah, jumlahMATKUL);

      // Menginput data setiap mata kuliah
      for j := 0 to jumlahMATKUL - 1 do
      begin
        writeln;
        writeln('Mata Kuliah ke-', j + 1);

        with mataKuliah[j] do
        begin
          write('Nama mata kuliah     : ');
          readln(NamaMATKUL);

          repeat
            write('Jumlah SKS           : ');
            readln(jumlahSKS);
          until jumlahSKS > 0;

          // Mengubah input menjadi huruf kapital, lalu memastikan nilainya valid.
          repeat
            write('Nilai (A/B+/B/C+/C/D/E): ');
            readln(nilai);
            nilai := UpperCase(nilai);
          until BobotNilai(nilai) >= 0;
        end;
      end;
    end;
  end;
end;


// Procedure untuk menampilkan hasil studi seorang mahasiswa
procedure TampilkanDataMahasiswa(const data: mhs; nomorMahasiswa, jumlahmhs: integer);

var
  j, totalSKS: integer;
  lebarNo, lebarSKS, lebarSkor: integer;
  skor, totalSkor, IP: real;
  teksSkor: string;

begin
  clrscr;

  with data do
  begin
    writeln('Nama : ', nama);
    writeln('NIM  : ', nim);

    // Menyesuaikan lebar kolom angka dengan data agar tabel tetap sejajar.
    lebarNo := Length(IntToStr(jumlahMATKUL));
    if lebarNo < 2 then
      lebarNo := 2;
    lebarSKS := 3;
    lebarSkor := 5;

    totalSkor := 0;
    for j := 0 to jumlahMATKUL - 1 do
    begin
      with mataKuliah[j] do
      begin
        if Length(IntToStr(jumlahSKS)) > lebarSKS then
          lebarSKS := Length(IntToStr(jumlahSKS));

        skor := jumlahSKS * BobotNilai(nilai);
        totalSkor := totalSkor + skor;
        teksSkor := FormatFloat('0.0', skor);
        if Length(teksSkor) > lebarSkor then
          lebarSkor := Length(teksSkor);
      end;
    end;

    teksSkor := FormatFloat('0.0', totalSkor);
    if Length(teksSkor) > lebarSkor then
      lebarSkor := Length(teksSkor);

    writeln(GarisTabel(lebarNo, lebarSKS, lebarSkor));
    writeln('| ', IsiKolom('No', lebarNo), ' | ',
            IsiKolom('Mata Kuliah', 30), ' | ',
            IsiKolom('SKS', lebarSKS), ' | ',
            IsiKolom('Nilai', 5), ' | ',
            IsiKolom('Skor', lebarSkor), ' |');
    writeln(GarisTabel(lebarNo, lebarSKS, lebarSkor));

    totalSKS := 0;
    totalSkor := 0;

    // Menampilkan data mata kuliah dan menghitung skor
    for j := 0 to jumlahMATKUL - 1 do
    begin
      with mataKuliah[j] do
      begin
        skor := jumlahSKS * BobotNilai(nilai);

        totalSKS := totalSKS + jumlahSKS;
        totalSkor := totalSkor + skor;

        writeln('| ', IsiKolom(IntToStr(j + 1), lebarNo), ' | ',
                IsiKolom(NamaMATKUL, 30), ' | ',
                IsiKolom(IntToStr(jumlahSKS), lebarSKS), ' | ',
                IsiKolom(nilai, 5), ' | ',
                IsiKolom(FormatFloat('0.0', skor), lebarSkor), ' |');
      end;
    end;

    writeln(GarisTabel(lebarNo, lebarSKS, lebarSkor));
    writeln('| ', IsiKolom('', lebarNo), ' | ',
            IsiKolom('TOTAL SKOR', 30), ' | ',
            IsiKolom('', lebarSKS), ' | ',
            IsiKolom('', 5), ' | ',
            IsiKolom(FormatFloat('0.0', totalSkor), lebarSkor), ' |');
    writeln(GarisTabel(lebarNo, lebarSKS, lebarSkor));

    writeln('Jumlah SKS : ', totalSKS);

    // Menghitung Indeks Prestasi mahasiswa
    IP := totalSkor / totalSKS;

    writeln('IP         : ', IP:0:2);
    writeln;
  end;

  // Menunggu tombol ditekan sebelum menampilkan mahasiswa berikutnya
  if nomorMahasiswa < jumlahmhs then
    writeln('Tekan sembarang tombol untuk melihat data mahasiswa selanjutnya...')
  else
    writeln('Tekan sembarang tombol untuk mengakhiri program...');

  readkey;
end;


// Program utama
var
  daftarMhs: DaftarMahasiswa;
  jumlahmhs, i: integer;

begin
  clrscr;

  // Menginput data seluruh mahasiswa terlebih dahulu
  InputDataMahasiswa(daftarMhs, jumlahmhs);

  // Menampilkan hasil studi mahasiswa satu per satu
  for i := 0 to jumlahmhs - 1 do
  begin
    TampilkanDataMahasiswa(daftarMhs[i], i + 1, jumlahmhs);
  end;
end.