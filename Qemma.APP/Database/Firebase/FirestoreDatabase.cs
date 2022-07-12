namespace Qemma.APP.Database.Firebase
{
    public class FirestoreDatabase<TCollection>
    {
        private readonly FirestoreDb _db;
        private readonly CollectionReference _collectionReference;

        public FirestoreDatabase(FirestoreDb db)
        {
            _db = db;
            _collectionReference = _db.Collection(typeof(TCollection).GetCollectionName());
        }

        private static TCollection SetDocId(TCollection model, string id)
        {
            if (model != null && model.GetType().GetProperty("Id") != null)
                model.GetType().GetProperty("Id")?.SetValue(model, id);

            return model;
        }

        public async Task<TCollection> GetByKeyAsync(string key)
        {
            try
            {
                var documentSnapshot = await _collectionReference.Document(key).GetSnapshotAsync();
                if (!documentSnapshot.Exists)
                {
                    return default;
                }
                var model = documentSnapshot.ConvertTo<TCollection>();
                model = SetDocId(model, documentSnapshot.Id);
                return model;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<PageResult<TCollection>> GetByFilterAsync(string filter = "", int pageNo = 1, int pageSize = -1, string orderDir = null, string orderBy = null)
        {
            try
            {
                var documentSnapshot = await _collectionReference.GetSnapshotAsync();
                if (!documentSnapshot.Any())
                {
                    return new PageResult<TCollection>();
                }
                var docs = documentSnapshot.Select(d =>
                {
                    var model = d.ConvertTo<TCollection>();
                    model = SetDocId(model, d.Id);
                    return model;
                })
                .Order(orderDir, orderBy)
                .CreateFilterExpression(filter)
                .ToPage(pageNo, pageSize);

                return docs;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<string> AddAsync(TCollection data)
        {
            try
            {
                if (data is null) throw new ArgumentNullException(nameof(data));

                var documentRefrence = await _collectionReference.AddAsync(data);
                return documentRefrence.Id;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task UpdateAsync(string key, TCollection data)
        {
            try
            {
                if (data is null) throw new ArgumentNullException(nameof(data));

                await _collectionReference.Document(key).UpdateAsync(data.ToDictionary());
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task DeleteAsync(string key)
        {
            try
            {
                await _collectionReference.Document(key).DeleteAsync();
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
