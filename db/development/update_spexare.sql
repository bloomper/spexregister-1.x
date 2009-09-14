# This script updates spexare data according to received input, e.g. does not want circulars

# 0 = false, 1 = true

USE db_spexregister_dev;

# wantCirculars
UPDATE tbl_spexare SET wantCirculars = 0 WHERE lastName = 'Backhaus' and firstName = 'Erik';
UPDATE tbl_spexare SET wantCirculars = 0 WHERE lastName = 'Persson' and firstName = 'Tore';
UPDATE tbl_spexare SET wantCirculars = 0 WHERE lastName = 'Vaske' and firstName = 'Tommy';
UPDATE tbl_spexare SET wantCirculars = 0 WHERE lastName = 'Möller' and firstName = 'Christer';

# publishApproval
# j.christer.f.moller@spray.se
UPDATE tbl_spexare SET publishApproval = 0 WHERE lastName = 'Möller' and firstName = 'Christer';

